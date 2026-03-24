import Mathlib
open Topology

/--
Sunk costs: when irrevocable production decisions or input contracts have been made,
the firm's production set is restricted and inaction (the zero plan) is no longer feasible.
`L` is the number of commodities.
-/
structure SunkCostProductionSet (L : ℕ) where
  /-- The original production set before commitments. -/
  fullSet : Set (Fin L → ℝ)
  /-- The sunk commitment vector (irrevocable input deliveries / decisions already made). -/
  sunk : Fin L → ℝ
  /-- The restricted production set reflecting remaining choices given sunk commitments. -/
  restrictedSet : Set (Fin L → ℝ)
  /-- The sunk commitment is nontrivial (some cost is actually sunk). -/
  sunk_nontrivial : sunk ≠ 0
  /-- Every plan in the restricted set, when combined with the sunk commitment,
      must lie in the original production set. -/
  restricted_consistent : ∀ y ∈ restrictedSet, (fun i => y i + sunk i) ∈ fullSet
  /-- Inaction (the zero plan) is not feasible in the restricted set — the defining
      property of sunk costs violating the possibility of inaction. -/
  inaction_not_feasible : (0 : Fin L → ℝ) ∉ restrictedSet