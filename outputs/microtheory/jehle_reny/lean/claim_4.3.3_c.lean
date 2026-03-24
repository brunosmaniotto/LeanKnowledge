import Mathlib

theorem Claim_4_3_3_c
    (p mc : ℝ)
    (surplus_maximized : Prop)
    (pareto_improvable : Prop)
    (surplus_increasable : Prop)
    -- When p ≠ mc, surplus can be increased (integral not at max)
    (h_neq_increase : p ≠ mc → surplus_increasable)
    -- When surplus can be increased, a Pareto improvement is possible (Section 4.3.2)
    (h_increase_pareto : surplus_increasable → pareto_improvable)
    -- Surplus is maximized iff p = mc (first-order condition)
    (h_max_iff : surplus_maximized ↔ p = mc) :
    (p ≠ mc → pareto_improvable ∧ surplus_increasable) ∧
    (¬pareto_improvable → surplus_maximized) := by
  constructor
  · intro hne
    exact ⟨h_increase_pareto (h_neq_increase hne), h_neq_increase hne⟩
  · intro hnpi
    rw [h_max_iff]
    by_contra hne
    exact hnpi (h_increase_pareto (h_neq_increase hne))