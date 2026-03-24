import Mathlib

theorem claim_A1_2_3_b :
    ∀ x y : Fin 10, (x : ℕ) + 1 ≥ (y : ℕ) + 1 ∨ (y : ℕ) + 1 ≥ (x : ℕ) + 1 := by
  intro x y
  omega