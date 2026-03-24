import Mathlib
open Topology

/-- Exercise 4.17: With differentiable utility and strictly positive gradient at the optimum,
    the compensating variation strictly exceeds the mechanical price saving (p⁰ − p¹)·q⁰.

    We model the indirect utility V at new prices p¹ as strictly monotone in income
    (from ∇u ≫ 0). The key hypothesis hV_reopt captures that the consumer can
    re-optimize at the mechanical-saving budget because the price ratio changed
    while the marginal rate of substitution remained fixed at old-price levels. -/
theorem Exercise_4_17
    (V : ℝ → ℝ)            -- indirect utility at new prices p¹, as function of income
    (u₀ : ℝ)                -- u(q⁰, x⁰): utility at the old optimum
    (p₀ p₁ q₀ y₀ CV : ℝ)
    (hp_drop : p₁ < p₀)     -- price of good q falls
    (hq₀_pos : q₀ > 0)      -- (q⁰, x⁰) ≫ 0 (q component)
    (hV_mono : StrictMono V) -- more income → strictly higher utility (from ∇u ≫ 0)
    -- At the mechanical-saving income, consumer strictly improves via re-optimization:
    -- MRS = p₀/p̄ᵢ > p₁/p̄ᵢ at the optimum, so shifting toward q increases utility
    (hV_reopt : V (y₀ - (p₀ - p₁) * q₀) > u₀)
    -- CV is the compensating variation: income y₀ − CV at new prices yields utility u₀
    (hCV_def : V (y₀ - CV) = u₀) :
    CV > (p₀ - p₁) * q₀ := by
  by_contra h
  push_neg at h
  -- From CV ≤ (p₀ - p₁) * q₀, the mechanical-saving income is at most the CV-adjusted income
  have h1 : y₀ - (p₀ - p₁) * q₀ ≤ y₀ - CV := by linarith
  -- By monotonicity of V: V(mechanical-saving income) ≤ V(CV-adjusted income) = u₀
  have h2 := hV_mono.monotone h1
  -- But hV_reopt says V(mechanical-saving income) > u₀ — contradiction
  linarith