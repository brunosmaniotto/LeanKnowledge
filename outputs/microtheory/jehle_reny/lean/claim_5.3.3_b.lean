import Mathlib

/-- Claim 5.3.3(b): Because excess demand is homogeneous of degree zero,
    Walrasian equilibrium prices are not unique: if p* is an equilibrium
    (z(p*) = 0), then lam • p* is also an equilibrium for any lam > 0. -/
theorem Claim_5_3_3_b
    {L : ℕ}
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (h_hom : ∀ (α : ℝ), 0 < α → ∀ (p : Fin L → ℝ), z (α • p) = z p)
    (p_star : Fin L → ℝ)
    (h_eq : z p_star = 0)
    (lam : ℝ)
    (hlam : 0 < lam) :
    z (lam • p_star) = 0 := by
  rw [h_hom _ hlam]; exact h_eq