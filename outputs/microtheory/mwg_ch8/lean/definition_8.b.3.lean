import Mathlib
open Topology

structure NormalFormGame where
  Player : Type*
  Strategy : Player → Type*
  utility : (i : Player) → ((j : Player) → Strategy j) → ℝ

def WeaklyDominates (G : NormalFormGame) [DecidableEq G.Player]
    (i : G.Player) (s'_i s_i : G.Strategy i) : Prop :=
  (∀ s : (j : G.Player) → G.Strategy j,
    G.utility i (Function.update s i s'_i) ≥ G.utility i (Function.update s i s_i)) ∧
  (∃ s : (j : G.Player) → G.Strategy j,
    G.utility i (Function.update s i s'_i) > G.utility i (Function.update s i s_i))