# Server Fixes Log

Fixes applied to adapt LeanKnowledge for the EML cluster at Berkeley.

## 1. Cloned repo directly to /scratch (2026-02-24)

**Problem:** `setup_server.sh` assumes the repo is cloned to `~/` and copies files
to `/scratch`. Since we cloned directly to `/scratch/public/brunosmaniotto/leanknowledge`,
the `cp` commands would try to copy files onto themselves.

**Fix:** Ran the useful parts of the setup script manually (mkdir, .env creation)
and skipped the redundant `cp` commands.

**Files affected:** None modified; setup_server.sh was bypassed.

## 2. Removed `module load cuda` from SLURM scripts (2026-02-24)

**Problem:** All three SLURM scripts had `module load python cuda`, but no `cuda`
module exists on this cluster (`module avail cuda` returns nothing). This would
cause jobs to fail at submission.

**Fix:** Changed `module load python cuda` to `module load python` in all three
scripts. Not needed because torch 2.6.0+cu126 (installed system-wide via Miniforge)
bundles its own CUDA 12.6 runtime.

**Files affected:**
- `training/slurm_train.sh` (line 15)
- `training/slurm_eval.sh` (line 15)
- `training/slurm_repair.sh` (line 15)

## 3. Converted DOS line endings in SLURM scripts (2026-02-24)

**Problem:** All three SLURM scripts had DOS line endings (`\r\n`), causing
`sbatch: error: Batch script contains DOS line breaks` on submission.

**Fix:** Ran `sed -i 's/\r$//'` on all three scripts to convert to Unix line
endings (`\n`).

**Files affected:**
- `training/slurm_train.sh`
- `training/slurm_eval.sh`
- `training/slurm_repair.sh`

## 4. Renamed `evaluation_strategy` to `eval_strategy` in train_translator.py (2026-02-24)

**Problem:** Job 498717 failed after 22 min (model downloaded successfully but crashed
on `TrainingArguments` init). The `evaluation_strategy` parameter was renamed to
`eval_strategy` in transformers >= 4.46.

**Fix:** Changed `evaluation_strategy="steps"` to `eval_strategy="steps"` on line 150.

**Files affected:**
- `training/train_translator.py` (line 150)

## 5. Installed wandb for offline training logging (2026-02-25)

**Problem:** `report_to="wandb"` in TrainingArguments but wandb was not installed.
Would crash on Trainer init.

**Fix:** Installed wandb 0.25.0 (`pip install --user wandb`). WANDB_MODE=offline
is set in .env so no network calls during training.

## 6. Reverted: pad_token override must stay (2026-02-25)

**Problem:** Removing `tokenizer.pad_token = tokenizer.eos_token` (fix #6 attempt)
caused `RuntimeError: CUDA error: device-side assert triggered` on the first training
step (job 498761). The Qwen3 tokenizer's default pad_token_id (151643) equals
`tokenizer.vocab_size` (151643), which is at the embedding boundary and likely
causes an out-of-bounds index during forward pass.

**Fix:** Restored the original override. Using eos_token (id=151645) as pad_token
is safe because the model embedding has 151936 rows (config.vocab_size).

**Files affected:**
- `training/train_translator.py` (line 74)

## 7. Added then removed CUDA_LAUNCH_BLOCKING=1 (2026-02-25)

**Added:** To get accurate CUDA error tracebacks (helped diagnose fix #8).

**Removed:** After fix #8 resolved the crash, job 498763 ran at ~105s/step
(projected 22+ days). `CUDA_LAUNCH_BLOCKING=1` forces synchronous CUDA execution,
preventing GPU parallelism. Removed to restore normal training speed.

**Files affected:**
- `training/slurm_train.sh` (line 17)

## 8. Fixed shallow copy bug in tokenize_function — root cause of CUDA assert (2026-02-25)

**Problem:** Jobs 498761 and 498762 both failed with `CUDA error: device-side assert
triggered` in `embed_tokens(input_ids)`. The real cause: `tokenized["input_ids"].copy()`
is a *shallow* copy — the inner lists are shared between `input_ids` and `labels`.
When padding positions in `labels` are set to `-100`, `input_ids` is also corrupted.
The embedding layer then receives `-100` as an index, which is out of bounds.

**Fix:** Changed `.copy()` to `[ids[:] for ids in tokenized["input_ids"]]` which
creates independent copies of each inner list, so modifying `labels` no longer
mutates `input_ids`.

**Files affected:**
- `training/train_translator.py` (line 110)

## 9. Reduced max_seq_len from 2048 to 512 (2026-02-25)

**Problem:** Job 498765 ran at ~97s/step with 18,714 total steps, projecting ~21 days
of training (far exceeding the 24-hour SLURM limit). Token length analysis showed
median prompt length is only 188 tokens (P95 = 569), so padding every sequence to
2048 wastes ~88% of compute on padding tokens.

**Fix:** Changed `--max_seq_len` from 2048 to 512 in `slurm_train.sh`. This covers
93.4% of training examples without truncation and reduces per-step compute by ~4x.
Sequences longer than 512 tokens are truncated (6.6% of data).

**Files affected:**
- `training/slurm_train.sh` (line 33)

## 10. Added WANDB_MODE=offline to SLURM script (2026-02-25)

**Problem:** Job 498772 crashed with `wandb.errors.errors.UsageError: No API key
configured`. The `.env` file sets `WANDB_MODE=offline` but SLURM jobs don't source
`.env` — environment variables must be exported directly in the SLURM script.

**Fix:** Added `export WANDB_MODE=offline` to `slurm_train.sh` alongside the other
env exports.

**Files affected:**
- `training/slurm_train.sh` (line 14)

## 11. Dynamic padding, group_by_length, batch tuning, extended time limit (2026-02-25)

**Problem:** Job 498773 ran at ~22.6s/step × 18,714 steps = ~5 days, still too long
for comfortable cluster sharing. All sequences were statically padded to 512 tokens
despite median length being 188 tokens.

**Fixes (all zero-impact on model quality):**
1. **Dynamic padding**: Removed `padding="max_length"` from tokenizer; switched from
   `DataCollatorForLanguageModeling` to `DataCollatorForSeq2Seq(padding=True,
   label_pad_token_id=-100)` which pads each batch to its longest sequence only.
   Eliminates ~60% wasted compute on average.
2. **group_by_length=True**: Added to TrainingArguments so similar-length sequences
   are batched together, further reducing padding waste.
3. **batch_size 4→8, grad_accum 8→4**: Same effective batch size (32), identical
   gradient updates, but better GPU utilization with larger per-device batches.
4. **SLURM time 24h→7 days**: GPU partition allows up to 28 days. Set to 7 days
   as safety margin.

**Files affected:**
- `training/train_translator.py` (tokenize_function, imports, TrainingArguments, data_collator)
- `training/slurm_train.sh` (--time, --batch_size, --grad_accum)

## Cluster environment reference

| Resource | Value |
|---|---|
| Server | EML cluster, Berkeley |
| Login node | theil.berkeley.edu |
| GPU partition | `gpu` (node: blundell) |
| GPU | 1x NVIDIA A40, 48 GB VRAM |
| Python | 3.13.2 (Miniforge) |
| PyTorch | 2.6.0+cu126 (system-wide) |
| CUDA | Bundled with torch (no module) |
| Home quota | 5 GB |
| Scratch path | /scratch/public/brunosmaniotto (50 GB) |
| HF cache | /scratch/public/brunosmaniotto/.cache/huggingface |
