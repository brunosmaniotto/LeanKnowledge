import Mathlib

variable {Allocation : Type*}
variable (feasible : Set Allocation)
variable (u : Allocation → ℝ)

def IsWalrasianEquilibrium (x : Allocation) : Prop :=
  x ∈ feasible ∧ ∀ y ∈ feasible, u y ≤ u x