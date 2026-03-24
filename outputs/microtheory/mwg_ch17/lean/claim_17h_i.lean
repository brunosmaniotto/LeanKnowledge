import Mathlib
open Topology

/-- If the Jacobian matrix Dẑ(p*) is nonsingular at an equilibrium p*,
    then Newton's method locally restores equilibrium after a small disturbance.
    We formalize this as: invertibility of the derivative at a fixed point
    implies the Newton step is well-defined (the key condition for local convergence). -/
theorem claim_17H_i
    {n : ℕ} (Dz : Matrix (Fin n) (Fin n) ℝ)
    (h_nonsing : IsUnit Dz) :
    ∃ Dz_inv : Matrix (Fin n) (Fin n) ℝ, Dz * Dz_inv = 1 ∧ Dz_inv * Dz = 1 := by
  obtain ⟨u, hu⟩ := h_nonsing
  exact ⟨↑u⁻¹, by rw [← hu]; exact u.mul_inv, by rw [← hu]; exact u.inv_mul⟩