import Mathlib
open Topology
open BigOperators

/-- A player's payoff function in von Neumann–Morgenstern expected utility form.
    Assigns a real-valued utility to each outcome; lotteries are evaluated
    by expected utility. -/
structure PayoffFunction (Outcome : Type*) where
  /-- The utility assigned to each deterministic outcome. -/
  utility : Outcome → ℝ

/-- Evaluate a lottery (probability distribution over outcomes) by expected utility:
    U(p) = ∑ₒ p(o) · u(o). This is the von Neumann–Morgenstern evaluation. -/
noncomputable def PayoffFunction.expectedUtility {Outcome : Type*} [Fintype Outcome]
    (u : PayoffFunction Outcome) (p : Outcome → ℝ) : ℝ :=
  ∑ o : Outcome, p o * u.utility o