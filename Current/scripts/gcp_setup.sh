#!/usr/bin/env bash
# GCP instance setup for LeanKnowledge pipeline.
#
# Usage:
#   1. Create the instance:
#      gcloud compute instances create leanknowledge \
#        --zone=us-central1-a \
#        --machine-type=e2-standard-4 \
#        --boot-disk-size=80GB \
#        --boot-disk-type=pd-ssd \
#        --image-family=ubuntu-2404-lts-amd64 \
#        --image-project=ubuntu-os-cloud
#
#   2. SSH in:
#      gcloud compute ssh leanknowledge --zone=us-central1-a
#
#   3. Run this script:
#      bash gcp_setup.sh
#
#   4. Set API keys:
#      export ANTHROPIC_API_KEY="sk-ant-..."
#      export DEEPSEEK_API_KEY="sk-..."
#      (add to ~/.bashrc for persistence)

set -euo pipefail

echo "=== LeanKnowledge GCP Setup ==="

# --- System packages ---
echo "[1/6] Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y -qq git curl python3.12 python3.12-venv python3-pip

# --- elan + Lean ---
echo "[2/6] Installing elan (Lean version manager)..."
curl https://elan.lean-lang.org/install.sh -sSf | sh -s -- -y --default-toolchain none
source "$HOME/.elan/env"

# --- Lake project with Mathlib ---
echo "[3/6] Creating Lake project with Mathlib..."
mkdir -p ~/lean-project && cd ~/lean-project

# Initialize if not already done
if [ ! -f lakefile.toml ]; then
  lake init LeanKnowledge math
fi

# Pin toolchain
echo "leanprover/lean4:v4.16.0" > lean-toolchain

# Build Mathlib (downloads pre-built oleans, ~10 min)
echo "[4/6] Building Mathlib (this takes ~10 minutes on first run)..."
lake update
lake exe cache get  # download pre-built oleans instead of compiling
lake build

echo "  Lean + Mathlib ready."
lean --version

# --- Python + LeanKnowledge ---
echo "[5/6] Setting up Python environment..."
cd ~
if [ ! -d LeanKnowledge ]; then
  echo "  Clone your repo here: git clone <your-repo-url> LeanKnowledge"
  echo "  Or scp/rsync the Current/ directory."
else
  cd LeanKnowledge/Current
  python3.12 -m pip install -e ".[test]"
  python3.12 -m pytest tests/ -q
fi

# --- Environment ---
echo "[6/6] Setting up environment..."
cat >> ~/.bashrc << 'ENVEOF'

# LeanKnowledge
source "$HOME/.elan/env"
export LEAN_PROJECT_DIR="$HOME/lean-project"
# Set these:
# export ANTHROPIC_API_KEY="sk-ant-..."
# export DEEPSEEK_API_KEY="sk-..."
ENVEOF

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Clone/copy LeanKnowledge repo to ~/LeanKnowledge"
echo "  2. Add API keys to ~/.bashrc"
echo "  3. source ~/.bashrc"
echo "  4. cd ~/LeanKnowledge/Current"
echo "  5. python3.12 -m pip install -e '.[test]'"
echo ""
echo "ProofWiki workflow:"
echo "  1. python3.12 scripts/download_proofwiki.py --output data/proofwiki.json --summary"
echo "  2. python3.12 scripts/run_proofwiki.py --data data/proofwiki.json --category 'Number Theory' --max 10  # pilot"
echo "  3. python3.12 scripts/run_proofwiki.py --data data/proofwiki.json --backlog outputs/proofwiki/backlog.json  # resume/full"
