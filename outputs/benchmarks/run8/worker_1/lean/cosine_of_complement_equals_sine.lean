import Mathlib

open Real

theorem cos_complement_eq_sin (θ : ℝ) : cos (π / 2 - θ) = sin θ := by
  exact cos_pi_div_two_sub θ