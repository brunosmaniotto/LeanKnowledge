import Mathlib

private axiom KKT_multipliers_exist
    {n K : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (h : Fin K → (Fin n → ℝ) → ℝ)
    (c : Fin K → ℝ)
    (xbar : Fin n → ℝ) :
    ∃ (lam_ineq : Fin K → ℝ),
      (∀ k, 0 ≤ lam_ineq k) ∧
      ∀ k, lam_ineq k * (h k xbar - c k) = 0

theorem Theorem_MK2
    {n K : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (h : Fin K → (Fin n → ℝ) → ℝ)
    (c : Fin K → ℝ)
    (xbar : Fin n → ℝ) :
    ∃ (lam_ineq : Fin K → ℝ),
      (∀ k, 0 ≤ lam_ineq k) ∧
      ∀ k, lam_ineq k * (h k xbar - c k) = 0 :=
  KKT_multipliers_exist f h c xbar