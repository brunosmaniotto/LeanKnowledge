import Mathlib

open SimpleGraph

variable {V : Type*} [Fintype V] [DecidableEq V]

def HasHamiltonianCycle (G : SimpleGraph V) : Prop :=
  ∃ (v : V) (c : G.Walk v v), c.IsCycle ∧ ∀ w, w ∈ c.support