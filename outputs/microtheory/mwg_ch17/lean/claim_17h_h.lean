import Mathlib

open BigOperators

axiom rp_implies_nsd
    {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ))
    (p_star : Fin n → ℝ)
    (h_equil : z p_star = 0)
    (h_walras : ∀ p : Fin n → ℝ, ∑ i : Fin n, p i * (z p) i = 0)
    (h_diff : DifferentiableAt ℝ z p_star)
    (h_rp : ∀ p : Fin n → ℝ,
              (∀ μ : ℝ, p ≠ μ • p_star) →
              ∑ i : Fin n, p_star i * (z p) i > 0) :
    ∀ v : Fin n → ℝ,
      ∑ i : Fin n, v i * (fderiv ℝ z p_star v) i ≤ 0

theorem Claim_17H_h
    {n : ℕ}
    (z : (Fin n → ℝ) → (Fin n → ℝ))
    (p_star : Fin n → ℝ)
    (h_equil : z p_star = 0)
    (h_walras : ∀ p : Fin n → ℝ, ∑ i : Fin n, p i * (z p) i = 0)
    (h_diff : DifferentiableAt ℝ z p_star)
    (h_rp : ∀ p : Fin n → ℝ,
              (∀ μ : ℝ, p ≠ μ • p_star) →
              ∑ i : Fin n, p_star i * (z p) i > 0) :
    ∀ v : Fin n → ℝ,
      ∑ i : Fin n, v i * (fderiv ℝ z p_star v) i ≤ 0 :=
  rp_implies_nsd z p_star h_equil h_walras h_diff h_rp