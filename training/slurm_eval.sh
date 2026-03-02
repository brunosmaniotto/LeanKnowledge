#!/bin/bash
#SBATCH --job-name=lk-eval
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --output=/scratch/public/brunosmaniotto/leanknowledge/training/logs/eval_%j.log

# Scratch workspace
WORK=/scratch/public/brunosmaniotto/leanknowledge
export HF_HOME=/scratch/public/brunosmaniotto/.cache/huggingface
export PYTHONPATH=$WORK/training:$PYTHONPATH

module load python
# Note: no cuda module on this cluster; torch 2.6.0 bundles CUDA 12.6

# Ensure output directories exist
mkdir -p $WORK/training/results

cd $WORK

python training/eval_translator.py \
    --test_data training/data/test.json \
    --adapter_path training/adapters/translator_v0 \
    --base_model Goedel-LM/Goedel-Prover-V2-8B \
    --num_samples 10 \
    --output training/results/eval_v0.json
