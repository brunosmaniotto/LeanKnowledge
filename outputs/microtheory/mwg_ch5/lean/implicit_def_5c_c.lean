import Mathlib
open Topology
open BigOperators

/-- A production vector (netput vector) in an economy with `L` commodities. -/
abbrev ProductionVector (L : ℕ) := Fin L → ℝ

/-- A production set: all feasible production plans for a firm. -/
abbrev ProductionSet (L : ℕ) := Set (Fin L → ℝ)

/-- The firm's profit function π(p) = sup{p · y : y ∈ Y}.
    Given a price vector p and production set Y, this returns the supremum
    of profit p · y over all feasible production plans y ∈ Y.
    When Y is compact and nonempty, the sup is attained and equals the max. -/
noncomputable def profitFunction {L : ℕ} (Y : ProductionSet L) (p : Fin L → ℝ) : EReal :=
  ⨆ y ∈ Y, (↑(∑ i : Fin L, p i * y i) : EReal)