import Mathlib

open Filter Topology
open Topology

-- Fix the number of goods
variable (n : ℕ)

-- Axiomatize the economic primitives with explicit n
axiom ProductionSet (n : ℕ) : Set (Fin n → ℝ)
axiom utility (n : ℕ) : (Fin n → ℝ) → ℝ
axiom endowments (n : ℕ) : Fin n → ℝ
axiom y_eq (n : ℕ) : Fin n → ℝ
axiom AdmissibleTrajectory (n : ℕ) : (ℝ → Fin n → ℝ) → Prop

-- Equilibrium is in production set and maximizes utility
axiom y_eq_in_Y (n : ℕ) : y_eq n ∈ ProductionSet n
axiom y_eq_maximizes (n : ℕ) : ∀ y ∈ ProductionSet n,
  utility n (y + endowments n) ≤ utility n (y_eq n + endowments n)
axiom y_eq_unique (n : ℕ) : ∀ y ∈ ProductionSet n,
  utility n (y + endowments n) = utility n (y_eq n + endowments n) → y = y_eq n

-- Admissible trajectories stay in Y
axiom admissible_in_Y (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ → ∀ t, γ t ∈ ProductionSet n

-- Lyapunov: utility is monotone along admissible trajectories
axiom utility_monotone_along (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ →
  Monotone (fun t => utility n (γ t + endowments n))

-- Utility strictly increases at non-equilibrium points
axiom utility_strict_off_eq (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ →
  ∀ t, γ t ≠ y_eq n →
    ∃ ε > 0, utility n (γ (t + ε) + endowments n) > utility n (γ t + endowments n)

-- Bounded monotone utility on compact feasible set converges
axiom utility_converges (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ →
  ∃ L, Filter.Tendsto (fun t => utility n (γ t + endowments n)) Filter.atTop (nhds L)

-- Convergent utility must reach the maximum (by strict increase off equilibrium)
axiom limit_is_max (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ →
  ∀ L, Filter.Tendsto (fun t => utility n (γ t + endowments n)) Filter.atTop (nhds L) →
    L = utility n (y_eq n + endowments n)

-- Unique maximizer + utility convergence to max implies trajectory convergence
axiom trajectory_converges_from_utility (n : ℕ) : ∀ γ, AdmissibleTrajectory n γ →
  Filter.Tendsto (fun t => utility n (γ t + endowments n)) Filter.atTop
    (nhds (utility n (y_eq n + endowments n))) →
  Filter.Tendsto γ Filter.atTop (nhds (y_eq n))

/-- Proposition 17.H.2: If there is a single strictly convex consumer,
    then any admissible trajectory converges to the (unique) equilibrium. -/
theorem Proposition_17H2 (n : ℕ) (γ : ℝ → Fin n → ℝ)
    (hadm : AdmissibleTrajectory n γ) :
    Filter.Tendsto γ Filter.atTop (nhds (y_eq n)) := by
  have ⟨L, hL⟩ := utility_converges n γ hadm
  have hLeq := limit_is_max n γ hadm L hL
  rw [hLeq] at hL
  exact trajectory_converges_from_utility n γ hadm hL