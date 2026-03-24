import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A barter equilibrium is a feasible allocation from which no coalition can profitably
    deviate using only their own endowments — i.e., a core allocation.
    A coalition S blocks x if there exists a reallocation y that is resource-feasible
    for S, weakly preferred by all members, and strictly preferred by some member. -/
structure BarterEquilibrium
    {I : Type*} [Fintype I] [DecidableEq I]
    {L : ℕ}
    (u : I → (Fin L → ℝ) → ℝ)
    (endow : I → Fin L → ℝ)
    (feasible : Set (I → Fin L → ℝ)) where
  /-- The equilibrium allocation -/
  x : I → Fin L → ℝ
  /-- The allocation is feasible -/
  x_feasible : x ∈ feasible
  /-- No coalition can block: there is no nonempty coalition S with a reallocation y
      that redistributes S's endowments while making all members weakly better off
      and at least one member strictly better off -/
  no_blocking : ∀ (S : Finset I), S.Nonempty →
    ¬∃ (y : I → Fin L → ℝ),
      (∀ l : Fin L, ∑ i ∈ S, y i l = ∑ i ∈ S, endow i l) ∧
      (∀ i ∈ S, u i (y i) ≥ u i (x i)) ∧
      (∃ i ∈ S, u i (y i) > u i (x i))