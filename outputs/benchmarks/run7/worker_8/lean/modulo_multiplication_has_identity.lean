import Mathlib

theorem ZMod.mul_has_identity (m : ℕ) : ∀ (x : ZMod m), x * (1 : ZMod m) = x ∧ (1 : ZMod m) * x = x := by
  intro x
  exact ⟨mul_one x, one_mul x⟩