import Mathlib

/-- A monetary lottery over continuous nonnegative monetary outcomes,
    described by a cumulative distribution function F : ℝ → ℝ. -/
structure MonetaryLottery where
  /-- The cumulative distribution function. -/
  cdf : ℝ → ℝ
  /-- F is monotone nondecreasing. -/
  mono : Monotone cdf
  /-- F(x) ∈ [0, 1] for all x. -/
  cdf_mem_Icc : ∀ x, cdf x ∈ Set.Icc 0 1
  /-- F(x) = 0 for all x < 0 (support on nonnegative amounts). -/
  cdf_neg : ∀ x, x < 0 → cdf x = 0

/-- The lottery space ℒ: the set of all monetary lotteries. -/
def LotterySpace : Type := MonetaryLottery