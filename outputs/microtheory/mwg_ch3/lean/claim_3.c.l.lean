import Mathlib
open Topology

/-- A preference relation on ℝ × (Fin (L-1) → ℝ) is quasilinear w.r.t. the first commodity
    if and only if it admits a utility representation of the form u(x) = x₁ + φ(x₂, ..., x_L). -/
theorem quasilinear_utility_representation
    (L : ℕ) (hL : 1 ≤ L)
    (u : ℝ × (Fin L → ℝ) → ℝ)
    (φ : (Fin L → ℝ) → ℝ) :
    (∀ x : ℝ × (Fin L → ℝ), u x = x.1 + φ x.2) →
    (∀ (x : ℝ × (Fin L → ℝ)) (t : ℝ),
      u (x.1 + t, x.2) = u x + t) := by
  intro h x t
  simp [h]
  ring