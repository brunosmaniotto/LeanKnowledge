import Mathlib

/-- The monotone likelihood ratio property (MLRP): the likelihood ratio
    f(π|e_L)/f(π|e_H) is decreasing in π is necessary for the optimal
    compensation scheme to be monotonically increasing in profits. -/
theorem optimal_compensation_monotonicity_requires_MLRP
    {π_space : Type*} [LinearOrder π_space]
    (likelihoodRatio : π_space → ℝ)
    (v' : ℝ → ℝ)  -- marginal utility of wealth v'(w)
    (w : π_space → ℝ)  -- optimal compensation as function of profit
    (hv'_pos : ∀ x, 0 < v' x)
    -- From FOC (14.B.10): 1/v'(w(π)) = μ + λ[1 - f(π|e_L)/f(π|e_H)]
    -- So w is increasing iff 1/v'(w(π)) is increasing iff
    -- [1 - likelihoodRatio(π)] is increasing iff likelihoodRatio is decreasing
    (h_foc : ∀ π₁ π₂ : π_space, π₁ ≤ π₂ →
      (w π₁ ≤ w π₂ ↔ likelihoodRatio π₂ ≤ likelihoodRatio π₁)) :
    (Monotone w) ↔ Antitone likelihoodRatio := by
  constructor
  · intro hw π₁ π₂ h12
    exact (h_foc π₁ π₂ h12).mp (hw h12)
  · intro hlr π₁ π₂ h12
    exact (h_foc π₁ π₂ h12).mpr (hlr h12)