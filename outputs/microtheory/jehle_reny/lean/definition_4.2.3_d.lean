import Mathlib
open Topology

/-- A short-run equilibrium in monopolistic competition (Definition 4.2.3.d).
A Nash equilibrium in prices among a fixed finite number J̄ ≥ 1 of active firms.
Each active firm j chooses p_j to maximize π_j(p) given the prices chosen by others.
Inactive firms' prices are exogenously fixed and absorbed into the profit function π. -/
structure ShortRunEquilibrium where
  /-- Number of active firms -/
  J_bar : ℕ
  /-- At least one active firm -/
  hJ : J_bar ≥ 1
  /-- Profit function for active firm j, depending on the price vector of all active firms -/
  π : Fin J_bar → (Fin J_bar → ℝ) → ℝ
  /-- Equilibrium price profile of active firms -/
  p : Fin J_bar → ℝ
  /-- Nash equilibrium condition: no firm can increase profit by unilateral price deviation -/
  nash : ∀ j : Fin J_bar, ∀ p_j' : ℝ,
    π j (Function.update p j p_j') ≤ π j p