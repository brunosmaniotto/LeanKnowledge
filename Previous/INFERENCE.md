# Running the LeanKnowledge Translator Locally

## 1. Download the adapter

```bash
rsync -av --exclude='checkpoint-*' \
  brunosmaniotto@theil.berkeley.edu:/scratch/public/brunosmaniotto/leanknowledge/training/adapters/translator_v0/ \
  ./translator_v0/
```

This downloads ~350MB (the LoRA adapter weights + tokenizer). The base model is
fetched automatically from HuggingFace on first use (~16GB).

## 2. Install dependencies

```bash
pip install torch transformers peft bitsandbytes accelerate
```

> **Hardware**: Requires ~6GB VRAM for 4-bit inference (any modern GPU).
> CPU-only inference works but is very slow.

## 3. Run inference

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from peft import PeftModel

# Load model
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
)

base_model = "Goedel-LM/Goedel-Prover-V2-8B"
adapter_path = "./translator_v0"  # path to downloaded adapter

model = AutoModelForCausalLM.from_pretrained(
    base_model,
    quantization_config=bnb_config,
    device_map="auto",
    trust_remote_code=True,
)
model = PeftModel.from_pretrained(model, adapter_path)
model.eval()

tokenizer = AutoTokenizer.from_pretrained(adapter_path, trust_remote_code=True)

# Build a prompt
def make_prompt(nl_proof: str) -> str:
    return f"""### Instruction
Translate the following mathematical proof into Lean 4 code with Mathlib imports.

### Natural Language Proof
{nl_proof}

### Lean 4 Code
"""

# Generate Lean 4 code
def translate(nl_proof: str, max_new_tokens: int = 512) -> str:
    prompt = make_prompt(nl_proof)
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)

    with torch.no_grad():
        output = model.generate(
            **inputs,
            max_new_tokens=max_new_tokens,
            do_sample=False,         # greedy decoding for deterministic output
            pad_token_id=tokenizer.eos_token_id,
        )

    decoded = tokenizer.decode(output[0], skip_special_tokens=True)
    # Extract only the generated Lean 4 code (after the prompt)
    marker = "### Lean 4 Code"
    if marker in decoded:
        return decoded.split(marker)[-1].strip()
    return decoded.strip()


# Example usage
nl_proof = """
**Statement**: For all natural numbers n, n + 0 = n.
**Strategy**: Direct proof by the definition of addition.
**Proof**:
1. By the definition of addition, n + 0 = n for all n.
"""

lean_code = translate(nl_proof)
print(lean_code)
```

## 4. Prompt format

The model expects the natural language proof structured as:

```
**Statement**: <theorem statement>
**Strategy**: <proof strategy>
**Assumptions**:
- <assumption 1>
**Proof**:
1. <step 1> (by <justification>)
2. <step 2>
**Dependencies**:
- <Mathlib lemma>
```

Not all fields are required — the model handles partial inputs gracefully.
