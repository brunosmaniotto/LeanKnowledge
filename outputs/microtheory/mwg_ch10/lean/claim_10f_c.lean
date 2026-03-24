import Mathlib
open Topology

theorem long_run_competitive_equilibrium
    (p_star c_bar : ℝ) (q_star q_bar : ℝ) (J_star : ℝ)
    (x : ℝ → ℝ)
    (hq_bar_pos : q_bar > 0)
    (hx_pos : x c_bar > 0)
    (h_no_above : p_star > c_bar → False)
    (h_no_below : p_star < c_bar → False)
    (h_output : p_star = c_bar → q_star = q_bar)
    (h_clearing : p_star = c_bar → q_star = q_bar → J_star = x c_bar / q_bar)
    : p_star = c_bar ∧ q_star = q_bar ∧ J_star = x c_bar / q_bar := by
  have hp : p_star = c_bar := by
    by_contra h
    cases lt_or_gt_of_ne h with
    | inl hlt => exact h_no_below hlt
    | inr hgt => exact h_no_above hgt
  exact ⟨hp, h_output hp, h_clearing hp (h_output hp)⟩