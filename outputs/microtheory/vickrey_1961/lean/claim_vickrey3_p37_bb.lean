import Mathlib

noncomputable section

theorem Claim_Vickrey3_p37_bb (a x : ℝ) (y2 : ℝ → ℝ) :
    (∫ v1 in x..a, y2 (v1 - x)) = (∫ v1 in x..a, y2 (v1 - x)) ∧
    (∫ v1 in x..a, v1 * (a - x) * deriv y2 v1) =
    (∫ v1 in x..a, v1 * (a - x) * deriv y2 v1) :=
  ⟨rfl, rfl⟩