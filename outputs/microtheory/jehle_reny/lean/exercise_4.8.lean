import Mathlib

/-- In Cournot duopoly with linear demand p(Q) = a - bQ and constant marginal costs
    0 ≤ c₁ < c₂, firm 1 produces more and earns higher profits in Nash equilibrium.
    Nash equilibrium quantities: qᵢ* = (a - 2cᵢ + cⱼ)/(3b).
    Profits: πᵢ* = (a - 2cᵢ + cⱼ)²/(9b). -/
theorem Exercise_4_8
    (a b c₁ c₂ : ℝ)
    (hb : b > 0)
    (hc1_nn : 0 ≤ c₁)
    (hc_lt : c₁ < c₂)
    (ha : a > 2 * c₂ - c₁)  -- ensures interior equilibrium
    : -- Firm 1 produces more (greater market share)
      (a - 2 * c₁ + c₂) / (3 * b) > (a - 2 * c₂ + c₁) / (3 * b) ∧
      -- Firm 1 earns higher profits
      (a - 2 * c₁ + c₂) ^ 2 / (9 * b) > (a - 2 * c₂ + c₁) ^ 2 / (9 * b) := by
  have hdc : (0 : ℝ) < c₂ - c₁ := by linarith
  have hsum : (0 : ℝ) < 2 * a - c₁ - c₂ := by linarith
  constructor <;> simp only [div_eq_mul_inv]
  · exact mul_lt_mul_of_pos_right (by linarith) (by positivity)
  · exact mul_lt_mul_of_pos_right (by nlinarith [mul_pos hdc hsum]) (by positivity)