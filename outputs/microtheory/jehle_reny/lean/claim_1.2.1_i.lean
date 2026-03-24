import Mathlib

open Metric

/-- Local non-satiation rules out zones of indifference: there cannot exist an open ball
around any point x¹ such that every point in that ball is indifferent to x¹. -/
theorem Claim_1_2_1_i
    {X : Type*} [MetricSpace X]
    (u : X → ℝ)
    (lns : ∀ x : X, ∀ ε > 0, ∃ y : X, dist y x < ε ∧ u y > u x)
    (x1 : X) :
    ¬ ∃ ε > 0, ∀ y : X, dist y x1 < ε → u y = u x1 := by
  rintro ⟨ε, hε, hball⟩
  obtain ⟨y, hy_dist, hy_pref⟩ := lns x1 ε hε
  linarith [hball y hy_dist]