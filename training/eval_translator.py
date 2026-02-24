import os
import sys
import json
import argparse
import torch
from pathlib import Path
from tqdm import tqdm
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from peft import PeftModel

# Add src to path to import LeanCompiler
sys.path.append(str(Path(__file__).resolve().parents[1] / "src"))
from leanknowledge.lean.compiler import LeanCompiler
from leanknowledge.schemas import LeanCode

def parse_args():
    parser = argparse.ArgumentParser(description="Evaluate translator model")
    parser.add_argument("--test_data", type=str, default="training/data/test.json", help="Path to test data")
    parser.add_argument("--adapter_path", type=str, default="training/adapters/translator_v0", help="Path to LoRA adapter")
    parser.add_argument("--base_model", type=str, default="Goedel-LM/Goedel-Prover-V2-8B", help="Base model ID")
    parser.add_argument("--output", type=str, default="training/results/eval_v0.json", help="Output results file")
    parser.add_argument("--num_samples", type=int, default=1, help="Number of samples per problem (Pass@k)")
    parser.add_argument("--max_new_tokens", type=int, default=1024)
    parser.add_argument("--temperature", type=float, default=0.7)
    return parser.parse_args()

def extract_lean_code(text: str) -> str:
    """Extract code from ### Lean 4 Code block if present, else return raw text."""
    marker = "### Lean 4 Code"
    if marker in text:
        return text.split(marker)[1].strip()
    return text.strip()

def evaluate(args):
    # 1. Load Data
    with open(args.test_data, "r", encoding="utf-8") as f:
        test_data = json.load(f)
    
    print(f"Loaded {len(test_data)} test examples.")

    # 2. Load Model
    print(f"Loading model: {args.base_model} + {args.adapter_path}")
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_use_double_quant=True,
    )
    
    try:
        model = AutoModelForCausalLM.from_pretrained(
            args.base_model,
            quantization_config=bnb_config,
            device_map="auto",
            trust_remote_code=True
        )
        model = PeftModel.from_pretrained(model, args.adapter_path)
        tokenizer = AutoTokenizer.from_pretrained(args.base_model, trust_remote_code=True)
        tokenizer.pad_token = tokenizer.eos_token
    except Exception as e:
        print(f"Failed to load model: {e}")
        return

    # 3. Setup Compiler
    # Use a temp directory for compilation to avoid polluting the project
    compiler = LeanCompiler(project_dir=None) # Standalone compilation for now
    # Note: Ideally we should use a project with Mathlib if we want to check imports validly.
    # If project_dir is None, it runs `lean file.lean`. This requires `lean` in PATH and
    # assumes imports are available in LEAN_PATH or standard library.
    # For Rosetta Stone which uses Mathlib, we ideally need a Lake project context.
    # Let's try to detect the project root.
    project_root = Path(__file__).resolve().parents[1]
    if (project_root / "lakefile.toml").exists():
        compiler = LeanCompiler(project_dir=project_root)
    
    results = []
    
    # 4. Evaluation Loop
    model.eval()
    for example in tqdm(test_data):
        prompt = example["prompt"]
        # Strip the target output if it's in the prompt (data_loader formats full training pair).
        # Format: ### Instruction ... ### Natural Language Proof ... ### Lean 4 Code\n{code}
        # We cut off at ### Lean 4 Code

        input_prompt = prompt.split("### Lean 4 Code")[0] + "### Lean 4 Code\n"
        
        inputs = tokenizer(input_prompt, return_tensors="pt").to(model.device)
        
        # Generate samples
        generated_codes = []
        
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=args.max_new_tokens,
                num_return_sequences=args.num_samples,
                do_sample=True if args.num_samples > 1 else False,
                temperature=args.temperature,
                pad_token_id=tokenizer.eos_token_id
            )
            
        for output in outputs:
            decoded = tokenizer.decode(output, skip_special_tokens=True)
            # The model generates the full sequence including prompt. Extract the new part.
            # Usually we can just split by input_prompt, but tokenization might change slight chars.
            # Simpler: extract_lean_code logic
            generated_lean = extract_lean_code(decoded)
            generated_codes.append(generated_lean)
            
        # Verify
        passed = False
        compiled_codes = []
        
        for code in generated_codes:
            # We don't parse imports separately here, assuming the model writes `import ...`
            # But the compiler expects LeanCode object.
            # We'll just pass the whole code string.
            lean_obj = LeanCode(code=code, imports=[]) 
            success, errors = compiler.compile(lean_obj)
            compiled_codes.append({
                "code": code,
                "success": success,
                "errors": [e.message for e in errors]
            })
            if success:
                passed = True
        
        results.append({
            "id": example.get("id"),
            "input": input_prompt,
            "reference": example.get("lean_code"),
            "outputs": compiled_codes,
            "pass": passed
        })

    # 5. Metrics
    pass_1 = sum(1 for r in results if r["outputs"][0]["success"]) / len(results)
    pass_any = sum(1 for r in results if r["pass"]) / len(results)
    
    metrics = {
        "total": len(results),
        "pass@1": pass_1,
        f"pass@{args.num_samples}": pass_any,
    }
    
    print("Results:")
    print(json.dumps(metrics, indent=2))
    
    # 6. Save
    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump({"metrics": metrics, "details": results}, f, indent=2)
        
if __name__ == "__main__":
    evaluate(parse_args())
