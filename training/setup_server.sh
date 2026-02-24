#!/bin/bash
# Server setup script for QLoRA training on EML cluster.
# Run this once from your home directory after cloning/copying the repo.
#
# Usage: bash training/setup_server.sh

set -e

SCRATCH=/scratch/public/brunosmaniotto
WORK=$SCRATCH/leanknowledge

echo "=== Setting up training workspace ==="
echo "Scratch: $SCRATCH"
echo "Workspace: $WORK"

# 1. Create directory structure
mkdir -p $WORK/training/data
mkdir -p $WORK/training/logs
mkdir -p $WORK/training/adapters/translator_v0
mkdir -p $WORK/training/results
mkdir -p $SCRATCH/.cache/huggingface

# 2. Copy training code
echo "Copying training scripts..."
cp training/train_translator.py $WORK/training/
cp training/eval_translator.py $WORK/training/
cp training/train_repair.py $WORK/training/
cp training/prepare_data.py $WORK/training/
cp training/data_loader.py $WORK/training/
cp training/slurm_train.sh $WORK/training/
cp training/slurm_eval.sh $WORK/training/
cp training/slurm_repair.sh $WORK/training/

# 3. Copy training data (if already prepared locally)
if [ -f training/data/train.json ]; then
    echo "Copying pre-prepared data splits..."
    cp training/data/train.json $WORK/training/data/
    cp training/data/val.json $WORK/training/data/
    cp training/data/test.json $WORK/training/data/
    echo "  Done. Splits ready."
else
    echo "No pre-prepared data found. Copying Rosetta Stone pairs..."
    mkdir -p $WORK/rosetta_stone_pairs
    cp -r rosetta_stone/pairs/*.json $WORK/rosetta_stone_pairs/
    echo "  Done. Run prepare_data.py on the server to create splits."
fi

# 4. Set up environment variables
cat > $WORK/.env <<'EOF'
export HF_HOME=/scratch/public/brunosmaniotto/.cache/huggingface
export PYTHONPATH=/scratch/public/brunosmaniotto/leanknowledge/training:$PYTHONPATH
export WANDB_MODE=offline
EOF

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. source $WORK/.env"
echo "  2. pip install torch transformers peft bitsandbytes datasets accelerate scikit-learn"
echo "  3. If data not pre-prepared: cd $WORK && python training/prepare_data.py --pairs_dir rosetta_stone_pairs --output_dir training/data"
echo "  4. cd $WORK && sbatch training/slurm_train.sh"
echo ""
echo "Disk usage:"
du -sh $WORK 2>/dev/null || echo "  (run du -sh $WORK after setup)"
