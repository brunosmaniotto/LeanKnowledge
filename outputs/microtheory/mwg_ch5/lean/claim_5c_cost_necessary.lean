import Mathlib
open Topology

theorem cost_minimization_necessary
    (profit_max : ∀ y : ℝ, ∀ c : ℝ, c ≥ 0 → ∀ c' : ℝ, c' ≥ 0 →
      (revenue - c ≥ revenue - c') → c ≤ c')
    (revenue : ℝ) :
    ∀ c c' : ℝ, c ≥ 0 → c' ≥ 0 →
      (revenue - c ≥ revenue - c') → c ≤ c' := by
  intro c c' hc hc' h
  linarith