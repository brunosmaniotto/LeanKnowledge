# Utility Scripts

Helper scripts for the LeanKnowledge pipeline, allowing for offline processing and environment setup.

## 1. PDF Processing (`process_pdfs.py`)

Uses the `marker-pdf` library to convert PDFs in `Sources/` to high-quality Markdown. This step runs locally and avoids using expensive Claude Vision tokens for the initial text extraction.

**Prerequisites:**
```bash
pip install marker-pdf
```

**Usage:**
```bash
# Process all PDFs in Sources/
python scripts/process_pdfs.py

# Specify custom directories
python scripts/process_pdfs.py --source-dir my_pdfs --output-dir my_output
```

## 2. Model Setup (`setup_models.py`)

Downloads the Goedel-Prover-V2-8B model (and potentially others) from Hugging Face to a local `models/` directory. This prepares the environment for the local, fine-tuned Translator agent.

**Prerequisites:**
```bash
pip install huggingface_hub
```

**Usage:**
```bash
python scripts/setup_models.py
```

**Output:**
Models will be downloaded to `LeanKnowledge/models/` (this directory is git-ignored).
