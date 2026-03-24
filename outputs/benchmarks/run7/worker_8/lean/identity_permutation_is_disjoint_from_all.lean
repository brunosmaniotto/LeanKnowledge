import Mathlib

open Equiv

theorem identity_disjoint (α : Type*) (τ : Perm α) : Perm.Disjoint (1 : Perm α) τ :=
  fun x => Or.inl rfl