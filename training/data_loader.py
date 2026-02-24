import json
import os
import glob
from pathlib import Path
from datasets import Dataset

def format_nl_proof(nl_proof: dict) -> str:
    """
    Formats the structured natural language proof into a single string.
    """
    lines = []
    
    # Statement
    if nl_proof.get("statement"):
        lines.append(f"**Statement**: {nl_proof['statement']}")
    
    # Strategy
    if nl_proof.get("strategy"):
        lines.append(f"**Strategy**: {nl_proof['strategy']}")
        
    # Assumptions
    assumptions = nl_proof.get("assumptions", [])
    if assumptions:
        lines.append("**Assumptions**:")
        for asm in assumptions:
            lines.append(f"- {asm}")
            
    # Steps
    steps = nl_proof.get("steps", [])
    if steps:
        lines.append("**Proof**:")
        for i, step in enumerate(steps, 1):
            if isinstance(step, dict):
                content = step.get("content", str(step))
                justification = step.get("justification")
                if justification:
                    lines.append(f"{i}. {content} (by {justification})")
                else:
                    lines.append(f"{i}. {content}")
            else:
                lines.append(f"{i}. {step}")
                
    # Dependencies
    dependencies = nl_proof.get("dependencies", [])
    if dependencies:
        lines.append("**Dependencies**:")
        for dep in dependencies:
            lines.append(f"- {dep}")
            
    return "\\n".join(lines)

def format_prompt(pair: dict) -> str:
    """
    Formats a pair into the training prompt.
    """
    nl_description = format_nl_proof(pair["nl_proof"])
    lean_code = pair["lean_code"]
    
    return f"""### Instruction
Translate the following mathematical proof into Lean 4 code with Mathlib imports.

### Natural Language Proof
{nl_description}

### Lean 4 Code
{lean_code}"""

def get_weight(confidence: str) -> float:
    """
    Returns the weight for a given confidence level.
    """
    confidence = confidence.lower()
    if confidence == "high":
        return 1.0
    elif confidence == "medium":
        return 0.7
    elif confidence == "low":
        return 0.3
    else:
        return 0.5 # Default

def load_rosetta_stone(pairs_dir: str | Path) -> Dataset:
    """
    Loads all JSON files from the pairs directory and returns a HuggingFace Dataset.
    """
    pairs_dir = Path(pairs_dir)
    pattern = str(pairs_dir / "*.json")
    files = glob.glob(pattern)
    
    data = []
    
    for file_path in files:
        if Path(file_path).name == "index.json":
            continue
            
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = json.load(f)
                
            module_name = content.get("module", "unknown")
            
            for pair in content.get("pairs", []):
                # Basic validation
                if "nl_proof" not in pair or "lean_code" not in pair:
                    continue
                    
                nl_proof = pair["nl_proof"]
                lean_code = pair["lean_code"]
                metadata = pair.get("metadata", {})
                confidence = metadata.get("confidence", "medium") # Default to medium if not specified
                complexity = metadata.get("complexity", "moderate")
                
                # Format prompt
                prompt = format_prompt(pair)
                
                # Calculate weight
                weight = get_weight(confidence)
                
                data.append({
                    "id": pair.get("id", ""),
                    "module": module_name,
                    "prompt": prompt,
                    "lean_code": lean_code,
                    "confidence": confidence,
                    "complexity": complexity,
                    "weight": weight,
                    "nl_proof": nl_proof # Keep raw structured proof just in case
                })
                
        except json.JSONDecodeError:
            print(f"Warning: Failed to decode {file_path}")
        except Exception as e:
            print(f"Warning: Error processing {file_path}: {e}")
            
    return Dataset.from_list(data)

if __name__ == "__main__":
    # Test loading
    dataset = load_rosetta_stone("rosetta_stone/pairs")
    print(f"Loaded {len(dataset)} pairs.")
    if len(dataset) > 0:
        print("Sample prompt:")
        print(dataset[0]["prompt"])
