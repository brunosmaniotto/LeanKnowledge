import Mathlib

open MeasureTheory
open scoped symmDiff

/-- Consumer surplus at price-income pair (p, y), defined as the area under
    the Marshallian demand curve q(·, y) above price p. -/
noncomputable def consumerSurplus (q : ℝ → ℝ → ℝ) (p y : ℝ) : ℝ :=
  ∫ t in Set.Ioi p, q t y

/-- Change in consumer surplus due to a price change from p₀ to p₁,
    ΔCS = CS(p₁, y₀) - CS(p₀, y₀) = ∫_{p₁}^{p₀} q(p, y₀) dp. -/
noncomputable def changeConsumerSurplus (q : ℝ → ℝ → ℝ) (p₀ p₁ y₀ : ℝ) : ℝ :=
  ∫ p in p₁..p₀, q p y₀