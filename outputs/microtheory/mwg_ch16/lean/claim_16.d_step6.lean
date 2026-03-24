import Mathlib

theorem Claim_16D_step6
    (p sum_x sum_y ω r : ℝ)
    (h_eq : sum_x = sum_y + ω)
    (h_ge : p * sum_x ≥ r)
    (h_le : p * sum_x ≤ r) :
    p * sum_x = r ∧ p * (ω + sum_y) = r := by
  have h1 : p * sum_x = r := le_antisymm h_le h_ge
  constructor
  · exact h1
  · have : ω + sum_y = sum_x := by linarith
    rw [this]
    exact h1