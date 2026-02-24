"""
Model Setup Script

Downloads the Goedel-Prover-V2-8B model (and potentially others) from Hugging Face
to a local 'models' directory for use by the offline Translator agent.

Usage:
    python scripts/setup_models.py

Requirements:
    pip install huggingface_hub
"""

import argparse
from pathlib import Path
import sys

def download_model(repo_id: str, local_dir: Path):
    """Download a model snapshot from Hugging Face."""
    try:
        from huggingface_hub import snapshot_download
    except ImportError:
        print("Error: 'huggingface_hub' not found.")
        print("Please install it: pip install huggingface_hub")
        sys.exit(1)

    print(f"Downloading {repo_id} to {local_dir}...")
    try:
        snapshot_download(
            repo_id=repo_id,
            local_dir=local_dir,
            local_dir_use_symlinks=False,  # Better for Windows/portability usually
            resume_download=True
        )
        print(f"Successfully downloaded {repo_id}")
    except Exception as e:
        print(f"Failed to download {repo_id}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Download LLM models")
    parser.add_argument("--models-dir", type=Path, default=Path("models"), help="Directory to store models")
    args = parser.parse_args()

    # Define models to download
    # Goedel-Prover-V2-8B is the base for the Translator agent (Qwen3-8B, expert-iteration trained)
    target_model = "Goedel-LM/Goedel-Prover-V2-8B"
    
    # Create models directory
    model_path = args.models_dir / target_model.split("/")[-1]
    args.models_dir.mkdir(exist_ok=True)

    download_model(target_model, model_path)

    print("
Model setup complete.")
    print(f"Model path: {model_path.absolute()}")
    print("You can now configure the pipeline to use this path.")

if __name__ == "__main__":
    main()
