import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A TU (transferable utility) cooperative game on a finite player set `I`. -/
structure TUGame (I : Type*) [Fintype I] [DecidableEq I] where
  /-- The characteristic function assigning a value to each coalition. -/
  v : Finset I → ℝ

/-- The Shapley value for player `i` in coalition `S` of a TU-game.
    Defined via the standard combinatorial formula:
    Sh_i(S, v) = ∑_{T ⊆ S\{i}} [|T|!(|S|-|T|-1)! / |S|!] · [v(T ∪ {i}) - v(T)]
    This is the unique function satisfying:
    (1) Efficiency: ∑_{i ∈ S} Sh_i(S,v) = v(S)
    (2) Equal differences: Sh_i(S,v) - Sh_i(S\{h},v) = Sh_h(S,v) - Sh_h(S\{i},v)
        for all i, h ∈ S. -/
noncomputable def shapleyValue {I : Type*} [Fintype I] [DecidableEq I]
    (game : TUGame I) (S : Finset I) (i : I) : ℝ :=
  if i ∈ S then
    ∑ T ∈ (S.erase i).powerset,
      (Nat.factorial T.card * Nat.factorial (S.card - T.card - 1) : ℝ) /
        (Nat.factorial S.card : ℝ) *
        (game.v (T ∪ {i}) - game.v T)
  else 0