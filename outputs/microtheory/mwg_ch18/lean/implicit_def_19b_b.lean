import Mathlib
open Topology

/-- The technological possibilities of firm j represented by a production set.
    A contingent production plan y ∈ ℝ^(L*S) is feasible if for every state s,
    the input-output vector of physical commodities is feasible for firm j. -/
structure ContingentProductionSet (L S : ℕ) where
  /-- The production set Y_j ⊂ ℝ^(L*S) -/
  Y : Set (Fin L → Fin S → ℝ)
  /-- Per-state feasibility sets: what input-output vectors are feasible in each state -/
  feasible_in_state : Fin S → Set (Fin L → ℝ)
  /-- A contingent plan is in Y_j iff for every state s, the state-s slice is feasible -/
  mem_iff_all_states_feasible :
    ∀ y, y ∈ Y ↔ ∀ s : Fin S, (fun l => y l s) ∈ feasible_in_state s