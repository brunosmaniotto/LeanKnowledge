import Mathlib

/-- The money metric indirect utility function. Given an expenditure function `e`,
    an indirect utility function `v`, and a fixed reference price vector `p_bar`,
    this returns the wealth required at prices `p_bar` to achieve the utility level `v(p, w)`. -/
noncomputable def moneyMetricIndirectUtility
    {L : Type*} [Fintype L]
    (e : (L → ℝ) → ℝ → ℝ)
    (v : (L → ℝ) → ℝ → ℝ)
    (p_bar : L → ℝ)
    (p : L → ℝ)
    (w : ℝ)
    : ℝ :=
  e p_bar (v p w)

/-- The welfare change measure in dollars between two price regimes,
    using the money metric indirect utility function. -/
noncomputable def moneyMetricWelfareChange
    {L : Type*} [Fintype L]
    (e : (L → ℝ) → ℝ → ℝ)
    (v : (L → ℝ) → ℝ → ℝ)
    (p_bar : L → ℝ)
    (p₁ p₀ : L → ℝ)
    (w : ℝ)
    : ℝ :=
  moneyMetricIndirectUtility e v p_bar p₁ w - moneyMetricIndirectUtility e v p_bar p₀ w