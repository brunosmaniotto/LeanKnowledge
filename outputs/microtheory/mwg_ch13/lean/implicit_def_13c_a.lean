import Mathlib

/-- The signaling model setup from MWG Chapter 13C. -/
structure SignalingModel where
  /-- High type -/
  theta_H : ℝ
  /-- Low type -/
  theta_L : ℝ
  /-- Probability of high type -/
  lambda_prob : ℝ
  /-- Cost function c(e, θ) -/
  cost : ℝ → ℝ → ℝ
  /-- Type ordering -/
  h_thetaH_gt : theta_H > theta_L
  h_thetaL_pos : theta_L > 0
  h_lambda_pos : 0 < lambda_prob
  h_lambda_lt : lambda_prob < 1
  /-- Zero education costs nothing -/
  h_cost_zero : ∀ t, cost 0 t = 0
  /-- Positive marginal cost of education -/
  h_cost_e_pos : ∀ e t, e > 0 → deriv (fun e' => cost e' t) e > 0
  /-- Convex cost in education -/
  h_cost_ee_pos : ∀ e t, e > 0 → deriv (deriv (fun e' => cost e' t)) e > 0
  /-- Higher type has lower cost for positive education -/
  h_cost_t_neg : ∀ e t, e > 0 → deriv (fun t' => cost e t') t < 0
  /-- Single-crossing: higher type has lower marginal cost -/
  h_cost_et_neg : ∀ e t, e > 0 →
    deriv (fun t' => deriv (fun e' => cost e' t') e) t < 0

/-- Utility of a type θ worker choosing education e and receiving wage w. -/
noncomputable def SignalingModel.utility (M : SignalingModel) (w e t : ℝ) : ℝ :=
  w - M.cost e t