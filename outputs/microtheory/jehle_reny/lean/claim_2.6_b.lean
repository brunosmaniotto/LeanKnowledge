import Mathlib
open Finset BigOperators
open Topology
open BigOperators

/-- For an interior optimum (0 < β* < w) with positive expected return,
    the FOC is Σpᵢu′(w + β*rᵢ)rᵢ = 0 and the SOC (strict, from
    risk aversion) is Σpᵢu″(w + β*rᵢ)rᵢ² < 0. -/
theorem Claim_2_6_b
    {n : ℕ}
    (p : Fin n → ℝ) (r : Fin n → ℝ)
    (u' u'' : ℝ → ℝ)
    (w β_star : ℝ)
    (hp : ∀ i, 0 < p i)
    (h_risk_averse : ∀ x, u'' x < 0)
    (h_foc : ∑ i : Fin n, p i * u' (w + β_star * r i) * r i = 0)
    (h_nonzero : ∃ i : Fin n, r i ≠ 0) :
    (∑ i : Fin n, p i * u' (w + β_star * r i) * r i = 0) ∧
    (∑ i : Fin n, p i * u'' (w + β_star * r i) * r i ^ 2 < 0) := by
  refine ⟨h_foc, ?_⟩
  have h_le : ∀ i ∈ Finset.univ, p i * u'' (w + β_star * r i) * r i ^ 2 ≤ 0 := by
    intro i _
    have h1 : p i * u'' (w + β_star * r i) < 0 :=
      mul_neg_of_pos_of_neg (hp i) (h_risk_averse _)
    exact mul_nonpos_of_nonpos_of_nonneg (le_of_lt h1) (sq_nonneg _)
  have h_lt : ∃ i ∈ Finset.univ, p i * u'' (w + β_star * r i) * r i ^ 2 < 0 := by
    obtain ⟨j, hj⟩ := h_nonzero
    exact ⟨j, mem_univ _, mul_neg_of_neg_of_pos
      (mul_neg_of_pos_of_neg (hp j) (h_risk_averse _))
      (lt_of_le_of_ne (sq_nonneg _) (Ne.symm (pow_ne_zero 2 hj)))⟩
  have key := sum_lt_sum h_le h_lt
  simp only [sum_const_zero] at key
  exact key