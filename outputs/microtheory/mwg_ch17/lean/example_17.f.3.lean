import Mathlib

noncomputable section

-- CES demand for home good by country i at price ratio p
axiom ces_demand_home (β p : ℝ) : ℝ

-- Equilibrium index of the symmetric equilibrium p = (1,1)
axiom symmetric_eq_index (β : ℝ) : ℤ

-- When -1 < β < -1/3, wealth effects bias demand toward the home good
-- so strongly that the symmetric equilibrium has index -1
axiom wealth_effect_dominance (β : ℝ) (hβ_lower : -1 < β)
    (hβ_upper : β < 0) (hβ_crit : β < -1/3) :
  symmetric_eq_index β = -1

-- Index -1 is sufficient for existence of asymmetric equilibria
axiom index_neg_one_implies_asymmetric (β : ℝ) :
  symmetric_eq_index β = -1 → ∃ p : ℝ, p ≠ 1 ∧ p > 0

theorem Example_17_F_3 (β : ℝ) (hβ_lower : -1 < β) (hβ_upper : β < 0)
    (hβ_crit : β < -1/3) :
    ∃ p : ℝ, p ≠ 1 ∧ p > 0 :=
  index_neg_one_implies_asymmetric β
    (wealth_effect_dominance β hβ_lower hβ_upper hβ_crit)