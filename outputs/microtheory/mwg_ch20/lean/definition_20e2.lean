import Mathlib

/-- A stationary production path myopically supported by proportional prices
    p_t = α^t · p₀ with α = δ (the discount factor) is a modified golden rule path. -/
structure ModifiedGoldenRulePath where
  plan : ℝ × ℝ
  p₀ : ℝ
  δ : ℝ
  price : ℕ → ℝ := fun t => δ ^ t * p₀
  discount_positive : 0 < δ

/-- A golden rule path is a stationary production path myopically supported
    by constant prices p_t = p₀ (equivalently α = 1, r = 0). -/
structure GoldenRulePath where
  plan : ℝ × ℝ
  p₀ : ℝ
  price : ℕ → ℝ := fun _ => p₀