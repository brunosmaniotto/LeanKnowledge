import Mathlib

theorem ramsey_inverse_elasticity_rule
    (α ε₁ ε₂ : ℝ)
    (hα : 0 < α)
    (hε₁ : 0 < ε₁)
    (hε₂ : 0 < ε₂)
    (h_less_elastic : ε₁ < ε₂) :
    α / ε₂ < α / ε₁ := by
  exact div_lt_div_of_pos_left hα hε₁ h_less_elastic