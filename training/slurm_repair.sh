#!/bin/bash
#SBATCH --job-name=lk-train-repair
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/scratch/public/brunosmaniotto/leanknowledge/training/logs/repair_%j.log

# Scratch workspace
WORK=/scratch/public/brunosmaniotto/leanknowledge
export HF_HOME=/scratch/public/brunosmaniotto/.cache/huggingface
export PYTHONPATH=$WORK/training:$PYTHONPATH

module load python cuda

# Ensure output directories exist
mkdir -p $WORK/training/logs
mkdir -p $WORK/training/adapters/repair_v0

cd $WORK

python training/train_repair.py \
    --strategy_kb strategy_kb.json \
    --trajectories_dir training_data/search_trajectories \
    --base_model Goedel-LM/Goedel-Prover-V2-8B \
    --adapter_path training/adapters/translator_v0 \
    --output_dir training/adapters/repair_v0
