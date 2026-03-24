import Mathlib

/-
Example 19.C.2: In an exchange economy with aggregate risk (ω₁+ω₂ = (2,1)),
at equilibrium p₁/p₂ < π₁/π₂. When π₁ = π₂ = 1/2, this gives p₁ < p₂:
the scarcer state has a higher contingent commodity price.

We formalize the key economic conclusion: if the price ratio is less than
the probability ratio, and probabilities are equal, then p₁ < p₂.
-/

/-- With aggregate risk and concave utility, MRS < π₁/π₂ at Pareto optima.
    When π₁ = π₂, equilibrium prices satisfy p₁ < p₂ (scarcer state is pricier). -/
theorem Example_19C2
    (p₁ p₂ π₁ π₂ : ℝ)
    (hp₁ : 0 < p₁) (hp₂ : 0 < p₂)
    (hπ₁ : 0 < π₁) (hπ₂ : 0 < π₂)
    -- At equilibrium, price ratio equals MRS, which is less than probability ratio
    (h_mrs : p₁ / p₂ < π₁ / π₂)
    -- Equal probabilities (π₁ = π₂ = 1/2)
    (h_eq_prob : π₁ = π₂) :
    p₁ < p₂ := by
  have hπ₂_pos : (0 : ℝ) < π₂ := hπ₂
  rw [h_eq_prob] at h_mrs
  rw [div_self (ne_of_gt hπ₂_pos)] at h_mrs
  exact (div_lt_one hp₂).mp h_mrs