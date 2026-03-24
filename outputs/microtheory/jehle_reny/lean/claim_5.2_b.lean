import Mathlib

open Real

theorem Claim_5_2_b
    (α : ℝ) (hα₀ : 0 < α) (hα₁ : α < 1)
    (p w : ℝ) (hp : 0 < p) (hw : 0 < w) :
    let hf := (α * p / w) ^ (1 / (1 - α))
    let yf := (α * p / w) ^ (α / (1 - α))
    let profit := (1 - α) / α * w * hf
    0 < profit := by
  intro hf yf profit
  have hα₁' : 0 < 1 - α := by linarith
  have hαp : 0 < α * p := mul_pos hα₀ hp
  have hbase : 0 < α * p / w := div_pos hαp hw
  have hexp : 0 < 1 / (1 - α) := by positivity
  have hhf : 0 < hf := rpow_pos_of_pos hbase _
  show 0 < (1 - α) / α * w * hf
  positivity