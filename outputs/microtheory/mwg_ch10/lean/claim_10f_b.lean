import Mathlib
open Topology

theorem no_long_run_competitive_equilibrium
    (m : ℝ)
    (demand supply : ℝ → ℝ)
    (hd : ∀ p : ℝ, p ≤ m → demand p > 0)
    (hs_high : ∀ p : ℝ, p > m → ∀ M : ℝ, supply p > M)
    (hs_low : ∀ p : ℝ, p ≤ m → supply p = 0)
    : ¬ ∃ p : ℝ, supply p = demand p := by
  intro ⟨p, heq⟩
  by_cases h : p > m
  · have := hs_high p h (demand p + 1)
    linarith
  · push_neg at h
    have hsz := hs_low p h
    have hdp := hd p h
    linarith