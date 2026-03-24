import Mathlib

open MeasureTheory

theorem winning_bid_probability_nondecreasing
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (maxOpponentBid : Ω → ℝ)
    (pWin : ℝ → ENNReal)
    (hpWin : ∀ x : ℝ, pWin x = μ {ω | maxOpponentBid ω ≤ x}) :
    Monotone pWin := by
  intro a b hab
  rw [hpWin a, hpWin b]
  apply measure_mono
  intro ω hω
  simp only [Set.mem_setOf_eq] at hω ⊢
  linarith