import Mathlib

theorem CycleDecompositionOfConjugate {α : Type} (π ρ : Equiv.Perm α) (i : α) :
    (π * ρ * π⁻¹) (π i) = π (ρ i) := by
  simp [Equiv.Perm.mul_apply, Equiv.symm_apply_apply]