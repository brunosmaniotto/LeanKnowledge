import Mathlib
open Finset
open BigOperators
set_option linter.unusedVariables false

theorem Claim_VCG_not_BB_IR : ∃ (N : ℕ) (v : Fin N → ℝ) (decision : (Fin N → ℝ) → Bool) 
    (payment : (Fin N → ℝ) → Fin N → ℝ),
    (∑ i : Fin N, payment v i ≠ 0) ∧ 
    (∃ i : Fin N, (if decision v then v i else 0) - payment v i < 0) := by
  use 2
  use ![ -1, 2 ]
  use λ w => w 0 + w 1 ≥ 0
  use λ w i =>
    match i with
    | 0 => (if w 1 ≥ 0 then w 1 else 0) - (if w 0 + w 1 ≥ 0 then w 1 else 0)
    | 1 => (if w 0 ≥ 0 then w 0 else 0) - (if w 0 + w 1 ≥ 0 then w 0 else 0)
  constructor
  · rw [Fin.sum_univ_two]
    norm_num
  · use 0
    norm_num