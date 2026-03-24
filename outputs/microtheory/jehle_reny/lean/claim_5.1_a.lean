import Mathlib

open BigOperators Finset

variable {I L : Type*} [Fintype I] [Fintype L]

def IsFeasible (x e : I → L → ℝ) : Prop :=
  ∀ l : L, ∑ i, x i l = ∑ i, e i l

structure IsBarterEquilibrium (x e : I → L → ℝ) : Prop where
  feasible : IsFeasible x e
  no_blocking : ∀ (S : Finset I), S.Nonempty →
    ¬∃ x' : I → L → ℝ, (∀ l, ∑ i ∈ S, x' i l = ∑ i ∈ S, e i l) ∧
      ∀ i ∈ S, x' i ≠ x i