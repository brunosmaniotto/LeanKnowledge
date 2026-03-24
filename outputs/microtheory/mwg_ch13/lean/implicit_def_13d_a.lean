import Mathlib
open Topology

/-- The screening model with task levels as a signaling device. -/
structure ScreeningModel where
  /-- High type productivity -/
  thetaH : ℝ
  /-- Low type productivity -/
  thetaL : ℝ
  /-- Probability of high type -/
  prob : ℝ
  /-- Cost function c(t, theta) -/
  c : ℝ → ℝ → ℝ
  /-- Type ordering -/
  thetaL_pos : 0 < thetaL
  thetaH_gt : thetaL < thetaH
  prob_pos : 0 < prob
  prob_lt_one : prob < 1
  /-- c(0, theta) = 0 for all theta -/
  cost_zero : ∀ th : ℝ, c 0 th = 0
  /-- c_t > 0 for t > 0 -/
  cost_t_pos : ∀ t th : ℝ, 0 < t → 0 < deriv (fun s => c s th) t
  /-- c_{tt} > 0 -/
  cost_tt_pos : ∀ t th : ℝ, 0 < t → 0 < deriv (deriv (fun s => c s th)) t
  /-- c_theta < 0 for t > 0 -/
  cost_th_neg : ∀ t th : ℝ, 0 < t → deriv (fun x => c t x) th < 0
  /-- c_{t,theta} < 0 (single-crossing) -/
  cost_tth_neg : ∀ t th : ℝ, 0 < t → deriv (fun x => deriv (fun s => c s x) t) th < 0

namespace ScreeningModel

/-- Utility: u(w, t | theta) = w - c(t, theta) -/
noncomputable def utility (M : ScreeningModel) (w t th : ℝ) : ℝ :=
  w - M.c t th

/-- Output of a type theta worker is theta regardless of task level -/
def output (_M : ScreeningModel) (th _t : ℝ) : ℝ := th

end ScreeningModel