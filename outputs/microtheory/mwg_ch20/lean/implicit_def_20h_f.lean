import Mathlib
open Filter
open Topology

/-- A steady-state equilibrium is determinate if it is locally isolated (no other equilibrium
trajectory remains in an arbitrarily small neighborhood), and indeterminate if a continuum
of equilibrium trajectories converge to it. -/
structure SteadyStateDeterminacy (State : Type*) [TopologicalSpace State] where
  /-- The steady-state equilibrium point -/
  steadyState : State
  /-- Predicate identifying equilibrium trajectories -/
  isEquilibriumTrajectory : (ℕ → State) → Prop
  /-- The constant trajectory at the steady state is an equilibrium trajectory -/
  steadyState_is_eq_traj : isEquilibriumTrajectory (fun _ => steadyState)
  /-- Determinate: for every neighborhood of the steady state, the only equilibrium trajectory
      staying entirely within that neighborhood is the constant steady-state trajectory -/
  isDeterminate : Prop :=
    ∀ U ∈ nhds steadyState,
      ∀ traj : ℕ → State, isEquilibriumTrajectory traj →
        (∀ n, traj n ∈ U) → traj = fun _ => steadyState
  /-- Indeterminate: there exists an uncountable family of distinct equilibrium trajectories
      converging to the steady state -/
  isIndeterminate : Prop :=
    ∃ F : ℝ → (ℕ → State),
      (∀ r, isEquilibriumTrajectory (F r)) ∧
      (∀ r, Filter.Tendsto (F r) Filter.atTop (nhds steadyState)) ∧
      (∀ r₁ r₂, r₁ ≠ r₂ → F r₁ ≠ F r₂)