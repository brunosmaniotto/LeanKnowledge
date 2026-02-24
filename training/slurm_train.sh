#!/bin/bash
#SBATCH --job-name=lk-train-translator
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=/scratch/public/brunosmaniotto/leanknowledge/training/logs/train_%j.log

# Scratch workspace
WORK=/scratch/public/brunosmaniotto/leanknowledge
export HF_HOME=/scratch/public/brunosmaniotto/.cache/huggingface
export PYTHONPATH=$WORK/training:$PYTHONPATH

module load python cuda

# Ensure output directories exist
mkdir -p $WORK/training/logs
mkdir -p $WORK/training/adapters/translator_v0

cd $WORK

python training/train_translator.py \
    --data_dir training/data \
    --output_dir training/adapters/translator_v0 \
    --base_model Goedel-LM/Goedel-Prover-V2-8B \
    --epochs 3 \
    --batch_size 4 \
    --grad_accum 8 \
    --lr 2e-4 \
    --max_seq_len 2048 \
    --lora_rank 64 \
    --lora_alpha 128
