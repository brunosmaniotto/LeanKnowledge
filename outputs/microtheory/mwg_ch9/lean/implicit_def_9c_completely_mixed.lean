import Mathlib
open Topology

/-- A completely mixed strategy assigns strictly positive probability to every
    action at every information set of the player. -/
def IsCompletelyMixed {n : ℕ} {Action : Fin n → Type*} {InfoSet : Fin n → Type*}
    [∀ i, Fintype (Action i)] [∀ i, Fintype (InfoSet i)]
    (σ : ∀ i, InfoSet i → Action i → ℝ) : Prop :=
  ∀ (i : Fin n) (h : InfoSet i) (a : Action i), 0 < σ i h a