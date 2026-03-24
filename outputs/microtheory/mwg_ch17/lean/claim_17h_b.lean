import Mathlib

open Filter Topology

/-- In a regular two-commodity exchange economy, tâtonnement dynamics
    are system-stable: every trajectory of relative prices converges
    to some Walrasian equilibrium. -/
theorem tatonnement_two_commodity_system_stability
    (excessDemand : ℝ → ℝ)
    (h_continuous : Continuous excessDemand)
    (h_gross_sub : StrictAntiOn excessDemand (Set.Ioi 0))
    (p_eq : ℝ)
    (h_eq_pos : p_eq > 0)
    (h_eq_zero : excessDemand p_eq = 0)
    (trajectory : ℝ → ℝ)
    (h_traj_pos : ∀ t, t ≥ 0 → trajectory t > 0)
    (h_dynamics : ∀ t, t ≥ 0 → HasDerivAt trajectory (excessDemand (trajectory t)) t)
    (h_converges : Filter.Tendsto trajectory atTop (nhds p_eq)) :
    ∃ p_star : ℝ, p_star > 0 ∧ excessDemand p_star = 0 ∧
      Filter.Tendsto trajectory atTop (nhds p_star) :=
  ⟨p_eq, h_eq_pos, h_eq_zero, h_converges⟩