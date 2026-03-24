import Mathlib

/-- Exercise 4.26(b): With per-unit tax t > 0 on each firm with cost c(q) = k² + q²,
    the modified cost c(q) = k² + q² + tq yields a higher long-run equilibrium price
    (from zero-profit condition at efficient scale q* = k), so fewer firms operate. -/
theorem Exercise_4_26_b
    (k t : ℝ) (hk : k > 0) (ht : t > 0)
    (p₀ p₁ : ℝ)
    -- Zero-profit at efficient scale q* = k, no tax: p₀·k = k² + k²
    (hp₀ : p₀ * k = k ^ 2 + k ^ 2)
    -- Zero-profit at efficient scale q* = k, with tax: p₁·k = k² + k² + t·k
    (hp₁ : p₁ * k = k ^ 2 + k ^ 2 + t * k)
    -- Demand is strictly decreasing
    (D : ℝ → ℝ) (hD : StrictAnti D) :
    -- Tax raises price and reduces number of firms
    p₁ > p₀ ∧ D p₁ < D p₀ := by
  have hk_ne : k ≠ 0 := ne_of_gt hk
  have hdiff : (p₁ - p₀) * k = t * k := by linear_combination hp₁ - hp₀
  have hp_eq : p₁ - p₀ = t := mul_right_cancel₀ hk_ne hdiff
  exact ⟨by linarith, hD (by linarith)⟩