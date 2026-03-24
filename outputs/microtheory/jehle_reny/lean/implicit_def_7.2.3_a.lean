import Mathlib
open Topology

/-- A game with incomplete information where each player has a finite type set.
    Player i's type t_i ∈ T_i specifies their private information.
    The payoff u_i(s, t) depends on the joint strategy profile and joint type vector. -/
structure IncompleteInfoGame (I : Type*) [Fintype I] where
  /-- Type space for each player (finite set of possible types) -/
  T : I → Type*
  /-- Each type space is finite -/
  [instFintype : ∀ i, Fintype (T i)]
  /-- Strategy set for each player -/
  S : I → Type*
  /-- Payoff function for player i given joint strategy profile s and joint type vector t -/
  u : I → (∀ i, S i) → (∀ i, T i) → ℝ