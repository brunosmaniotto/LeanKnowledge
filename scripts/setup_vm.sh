#!/bin/bash
# ==========================================================================
# LeanKnowledge VM Setup Script
#
# Sets up a fresh Ubuntu VM for running the LeanKnowledge pipeline.
# Tested on: Ubuntu 24.04 LTS, e2-standard-4 (4 vCPU, 16 GB RAM)
#
# Usage:
#   # 1. Create a GCP VM (e2-standard-4, Ubuntu 24.04, 80GB disk)
#   # 2. SSH in and run:
#   curl -sSL https://raw.githubusercontent.com/brunosmaniotto/LeanKnowledge/main/scripts/setup_vm.sh | bash
#   # OR: scp this script to the VM and run it
#
# After setup, configure API keys in ~/.env_keys and start workers.
# ==========================================================================

set -euo pipefail

echo "=== LeanKnowledge VM Setup ==="
echo "This will install Python, Lean 4, Mathlib, and the LeanKnowledge pipeline."
echo ""

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
echo ">>> Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y -qq python3 python3-pip python3-venv git curl

# ---------------------------------------------------------------------------
# 2. Python virtual environment
# ---------------------------------------------------------------------------
echo ">>> Setting up Python venv..."
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install --upgrade pip -q

# ---------------------------------------------------------------------------
# 3. Clone LeanKnowledge
# ---------------------------------------------------------------------------
echo ">>> Cloning LeanKnowledge..."
if [ -d ~/LeanKnowledge ]; then
    echo "  LeanKnowledge already exists, pulling latest..."
    cd ~/LeanKnowledge && git pull
else
    cd ~ && git clone https://github.com/brunosmaniotto/LeanKnowledge.git
fi

cd ~/LeanKnowledge
pip install -e ".[test]" -q
echo "  Package installed. $(python3 -c 'import leanknowledge; print("OK")')"

# ---------------------------------------------------------------------------
# 4. Install Lean 4 via elan
# ---------------------------------------------------------------------------
echo ">>> Installing Lean 4 (elan)..."
if command -v elan &>/dev/null; then
    echo "  elan already installed, updating..."
    elan self update
else
    curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
fi
export PATH="$HOME/.elan/bin:$PATH"
echo 'export PATH="$HOME/.elan/bin:$PATH"' >> ~/.bashrc

lean --version

# ---------------------------------------------------------------------------
# 5. Set up Lean project with Mathlib (THE SLOW PART: ~60-90 min)
# ---------------------------------------------------------------------------
echo ">>> Setting up Lean project with Mathlib..."
if [ -d ~/lean-project ]; then
    echo "  lean-project already exists, updating Mathlib..."
    cd ~/lean-project && lake update
else
    mkdir -p ~/lean-project
    cd ~/lean-project

    # Create lakefile
    cat > lakefile.toml << 'LAKEFILE'
[package]
name = "LeanKnowledge"
leanOptions = []
moreLinkArgs = []
moreServerOptions = []

[[require]]
name = "mathlib"
scope = "leanprover-community"
LAKEFILE

    # Create lean-toolchain (match Mathlib's expected version)
    echo "leanprover/lean4:v4.16.0" > lean-toolchain

    # Create minimal source file
    mkdir -p LeanKnowledge
    echo "import Mathlib" > LeanKnowledge/Basic.lean
fi

echo ">>> Building Mathlib (this takes 60-90 minutes on first run)..."
echo ">>> Started at: $(date)"
lake build
echo ">>> Mathlib build complete at: $(date)"

# ---------------------------------------------------------------------------
# 6. Download ProofWiki dataset
# ---------------------------------------------------------------------------
echo ">>> Downloading ProofWiki dataset..."
cd ~/LeanKnowledge
mkdir -p data
if [ -f data/proofwiki.json ]; then
    echo "  Dataset already exists."
else
    python3 scripts/download_proofwiki.py --output data/proofwiki.json
fi

# ---------------------------------------------------------------------------
# 7. Build Mathlib declaration index (for RAG)
# ---------------------------------------------------------------------------
echo ">>> Building Mathlib declaration index..."
if [ -f data/mathlib_index.json ]; then
    echo "  Index already exists."
else
    python3 scripts/build_mathlib_index.py \
        --lean-project ~/lean-project \
        --output data/mathlib_index.json
fi

# ---------------------------------------------------------------------------
# 8. Create env_keys template
# ---------------------------------------------------------------------------
if [ ! -f ~/.env_keys ]; then
    cat > ~/.env_keys << 'ENVKEYS'
# LeanKnowledge API Keys
# Source this file before running workers: source ~/.env_keys

# Google Cloud / Vertex AI (for Gemini)
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
export VERTEXAI_PROJECT="your-project-id"
export VERTEXAI_LOCATION="us-central1"

# DeepSeek API
export DEEPSEEK_API_KEY="your-deepseek-key"

# Model routing — DeepSeek for direct+Tier1, Gemini for Tier2+decomposition
export LK_TRANSLATOR_DIRECT_MODEL=deepseek/deepseek-reasoner
export LK_TRANSLATOR_TIER1_MODEL=deepseek/deepseek-reasoner
export LK_TRANSLATOR_TIER2_MODEL=vertex_ai/gemini-2.5-pro
export LK_MODEL_HEAVY=vertex_ai/gemini-2.5-pro
export LK_TRANSLATOR_TIER3_MODEL=vertex_ai/gemini-2.5-pro
export LK_TRANSLATOR_TIER3_PROVER=vertex_ai/gemini-2.5-pro
ENVKEYS
    echo "  Created ~/.env_keys template — EDIT THIS with your API keys!"
else
    echo "  ~/.env_keys already exists."
fi

# ---------------------------------------------------------------------------
# 9. Create work queue for a run
# ---------------------------------------------------------------------------
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit ~/.env_keys with your API keys"
echo "  2. Create a work queue:"
echo "     cd ~/LeanKnowledge"
echo "     source ~/venv/bin/activate && source ~/.env_keys"
echo "     python3 scripts/create_work_queue.py --data data/proofwiki.json --max 1000 --offset 1000 --output outputs/run8/work_queue.json"
echo "  3. Start workers (e.g., 20 workers):"
echo "     nohup bash -c 'source ~/venv/bin/activate && source ~/.env_keys && for i in \$(seq 0 19); do python3 -u scripts/run_proofwiki.py --data data/proofwiki.json --lean-project ~/lean-project --output outputs/run8/worker_\$i --pool outputs/run8/work_queue.json --worker-id \$i --max-failures 50 --mathlib-index data/mathlib_index.json & done; wait' > ~/run8.log 2>&1 &"
echo "  4. Monitor:"
echo "     python3 -c \"import json; from collections import Counter; d=json.loads(open('outputs/run8/work_queue.json').read()); c=Counter(i['status'] for i in d['items']); print(c)\""
echo ""
