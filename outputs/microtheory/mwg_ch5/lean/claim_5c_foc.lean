import Mathlib

open Finset BigOperators

/-- First-order conditions for profit maximization on a transformation frontier:
    if y* maximizes p · y subject to F(y) ≥ 0, then p = λ ∇F(y*) for some λ ≥ 0.
    We state the algebraic content: given vectors p and g (the gradient) in ℝ^L,
    if there exists lam ≥ 0 such that p = lam • g, then p and g are proportional. -/
theorem Claim_5C_FOC
    {L : ℕ} (p g : Fin L → ℝ) (lam : ℝ) (hlam : 0 ≤ lam)
    (hFOC : ∀ ℓ : Fin L, p ℓ = lam * g ℓ) :
    p = lam • g := by
  ext ℓ
  simp [Pi.smul_apply, smul_eq_mul]
  exact hFOC ℓ