import Mathlib
open Topology

/-- A social welfare function satisfying nonpaternalism: if two alternatives
    give every agent the same utility, they are socially indifferent. -/
structure NonpaternalisticSWF (Agent Alternative : Type*) [Fintype Agent] where
  /-- Individual utility function for each agent -/
  utility : Agent → Alternative → ℝ
  /-- Social welfare function mapping a utility profile to a social ordering value -/
  W : (Agent → ℝ) → ℝ
  /-- Nonpaternalism: if every agent's utility is the same on two alternatives,
      the social welfare values are equal -/
  nonpaternalism :
    ∀ x y : Alternative,
      (∀ i : Agent, utility i x = utility i y) →
        W (fun i => utility i x) = W (fun i => utility i y)