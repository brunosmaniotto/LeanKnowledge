import Mathlib

open SimpleGraph

variable {V : Type} [Fintype V] [DecidableEq V]

def HasHamiltonianPath (G : SimpleGraph V) : Prop :=
  ∃ (v w : V) (p : G.Walk v w), p.IsPath ∧ p.support.toFinset = Finset.univ