import Mathlib

theorem reduced_residues_abelian_group (m : ℕ) : ∀ x y : (ZMod m)ˣ, x * y = y * x := by
  intro x y
  ext
  simp [mul_comm]