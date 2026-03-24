import Mathlib

open Set
open Topology

noncomputable section

/-- Pareto efficiency requires surplus maximization (p = mc) even when consumer
    surplus overstates dollar benefits due to income effects for normal goods.
    Under downward-sloping demand and rising marginal costs, the FOC p(q*) = mc(q*)
    characterizes the surplus-maximizing (Pareto efficient) quantity. -/
theorem Claim_4_3_3_e
    (p mc : ℝ → ℝ)
    (TS : ℝ → ℝ)
    (q_star : ℝ)
    (h_demand_down : StrictAntiOn p (Ici 0))
    (h_mc_up : StrictMonoOn mc (Ici 0))
    (h_TS_deriv : HasDerivAt TS (p q_star - mc q_star) q_star)
    (h_max : IsLocalMax TS q_star) :
    p q_star = mc q_star := by
  have h := h_max.hasDerivAt_eq_zero h_TS_deriv
  linarith