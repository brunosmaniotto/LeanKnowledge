import Mathlib
open Topology

theorem Lemma_13C2
    (θ_L : ℝ)
    (cost : ℝ → ℝ)
    (payoff : ℝ → ℝ → ℝ)
    (w_star : ℝ → ℝ)
    (e_star : ℝ)
    (h_payoff : ∀ w e, payoff w e = w - cost e)
    (h_cost_zero : cost 0 = 0)
    (h_cost_pos : ∀ e : ℝ, e > 0 → cost e > 0)
    (h_nonneg : e_star ≥ 0)
    (h_wage_sep : w_star e_star = θ_L)
    (h_wage_floor : ∀ e, w_star e ≥ θ_L)
    (h_equil : ∀ e, payoff (w_star e) e ≤ payoff (w_star e_star) e_star)
    : e_star = 0 := by
  by_contra h
  have h_pos : e_star > 0 := lt_of_le_of_ne h_nonneg (Ne.symm h)
  have h_dev := h_equil 0
  rw [h_payoff, h_payoff, h_wage_sep, h_cost_zero] at h_dev
  have h_floor := h_wage_floor 0
  have h_cp := h_cost_pos e_star h_pos
  linarith