import Mathlib

theorem Claim_8_price_higher_low_effort
    (u : ℝ → ℝ)
    (hu : StrictMono u)
    (w p₀ p₁ d₀ d₁ ū : ℝ)
    (h_pc0 : u (w - p₀) = d₀ + ū)
    (h_pc1 : u (w - p₁) = d₁ + ū)
    (hd : d₀ < d₁) :
    p₀ > p₁ := by
  have h1 : u (w - p₀) < u (w - p₁) := by linarith
  have h2 : w - p₀ < w - p₁ := hu.lt_iff_lt.mp h1
  linarith