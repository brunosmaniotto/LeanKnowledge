import os
import argparse
import torch
import json
from pathlib import Path
from datasets import load_dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    BitsAndBytesConfig,
    TrainingArguments,
    Trainer,
    DataCollatorForLanguageModeling
)
from peft import (
    LoraConfig,
    get_peft_model,
    prepare_model_for_kbit_training,
    TaskType
)

def parse_args():
    parser = argparse.ArgumentParser(description="Train QLoRA adapter for DeepSeek-Prover")
    parser.add_argument("--pairs_dir", type=str, default="rosetta_stone/pairs", help="Directory with pairs (used if preparing data on the fly)")
    parser.add_argument("--data_dir", type=str, default="training/data", help="Directory with train/val/test.json")
    parser.add_argument("--output_dir", type=str, default="training/adapters/translator_v0", help="Output directory for adapter")
    parser.add_argument("--base_model", type=str, default="Goedel-LM/Goedel-Prover-V2-8B", help="Base model path or ID")
    parser.add_argument("--epochs", type=int, default=3)
    parser.add_argument("--batch_size", type=int, default=4)
    parser.add_argument("--grad_accum", type=int, default=8)
    parser.add_argument("--lr", type=float, default=2e-4)
    parser.add_argument("--max_seq_len", type=int, default=2048)
    parser.add_argument("--lora_rank", type=int, default=64)
    parser.add_argument("--lora_alpha", type=int, default=128)
    parser.add_argument("--resume_from", type=str, default=None, help="Path to checkpoint to resume from")
    parser.add_argument("--dry_run", action="store_true", help="Load data and model but skip training")
    return parser.parse_args()

def main():
    args = parse_args()
    
    print(f"Starting training with output to {args.output_dir}")
    
    # 1. Load Data
    data_files = {
        "train": os.path.join(args.data_dir, "train.json"),
        "validation": os.path.join(args.data_dir, "val.json"),
    }
    
    # Check if files exist
    if not os.path.exists(data_files["train"]):
        print(f"Error: Train file {data_files['train']} not found. Run prepare_data.py first.")
        return

    dataset = load_dataset("json", data_files=data_files)
    
    # 2. Model & Tokenizer
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_use_double_quant=True,
    )

    print(f"Loading base model: {args.base_model}")
    model = AutoModelForCausalLM.from_pretrained(
        args.base_model,
        quantization_config=bnb_config,
        device_map="auto",
        trust_remote_code=True
    )
    
    tokenizer = AutoTokenizer.from_pretrained(args.base_model, trust_remote_code=True)
    tokenizer.pad_token = tokenizer.eos_token
    
    # 3. LoRA Setup
    model = prepare_model_for_kbit_training(model)
    
    target_modules = ["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]
    peft_config = LoraConfig(
        r=args.lora_rank,
        lora_alpha=args.lora_alpha,
        target_modules=target_modules,
        lora_dropout=0.05,
        bias="none",
        task_type=TaskType.CAUSAL_LM,
    )
    
    model = get_peft_model(model, peft_config)
    model.print_trainable_parameters()
    
    # 4. Tokenization
    def tokenize_function(examples):
        # The 'prompt' field in json already contains the full text (instruction + input + output)
        # We assume the prompt format is:
        # ### Instruction ... ### Natural Language Proof ... ### Lean 4 Code ...
        # Ideally we want to mask the loss for the instruction part, but for simplicity/robustness without trl,
        # we train on everything or try to find the split.
        
        # Simple CLM tokenization
        full_texts = examples["prompt"]
        
        tokenized = tokenizer(
            full_texts,
            truncation=True,
            max_length=args.max_seq_len,
            padding="max_length"
        )
        
        tokenized["labels"] = tokenized["input_ids"].copy()
        
        # Masking input (optional but recommended):
        # Find the start of "### Lean 4 Code" and mask everything before it.
        # This is a bit tricky with tokenization boundaries.
        # Simpler approach: Training on prompt is not fatal, just slightly less efficient.
        # Given this is a custom script without trl, we'll proceed with full CLM for now unless
        # we implement custom masking logic.
        
        # Masking padding tokens
        for i, input_id in enumerate(tokenized["input_ids"]):
            # Set labels to -100 where input is padding
            # Note: tokenizer.pad_token_id might be eos_token_id, be careful
            # attention_mask is 0 for padding
            if "attention_mask" in tokenized:
                mask = tokenized["attention_mask"][i]
                labels = tokenized["labels"][i]
                for j, m in enumerate(mask):
                    if m == 0:
                        labels[j] = -100
                        
        return tokenized

    print("Tokenizing dataset...")
    tokenized_datasets = dataset.map(tokenize_function, batched=True, remove_columns=dataset["train"].column_names)
    
    # 5. Training
    if args.dry_run:
        print("Dry run requested. Exiting before training loop.")
        return

    training_args = TrainingArguments(
        output_dir=args.output_dir,
        per_device_train_batch_size=args.batch_size,
        gradient_accumulation_steps=args.grad_accum,
        per_device_eval_batch_size=args.batch_size,
        num_train_epochs=args.epochs,
        learning_rate=args.lr,
        fp16=True,
        logging_steps=10,
        evaluation_strategy="steps",
        eval_steps=100,
        save_strategy="steps",
        save_steps=100,
        save_total_limit=3,
        load_best_model_at_end=False, # Often False for LoRA to avoid OOM or loading issues
        report_to="wandb",
        run_name="translator_v0",
        remove_unused_columns=False, # Important since we created custom labels
    )
    
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized_datasets["train"],
        eval_dataset=tokenized_datasets["validation"],
        data_collator=DataCollatorForLanguageModeling(tokenizer, mlm=False),
    )
    
    print("Starting training...")
    trainer.train(resume_from_checkpoint=args.resume_from)
    
    print("Saving final model...")
    trainer.save_model(args.output_dir)
    
    # Save tokenizer as well for convenience
    tokenizer.save_pretrained(args.output_dir)

if __name__ == "__main__":
    main()
