import Mathlib

open Finset

/- We admit the existence of an order isomorphism between a finite linearly ordered type and `Fin (card α)`. -/
noncomputable def orderIsoFin (α : Type) [Fintype α] [LinearOrder α] : α ≃o Fin (Fintype.card α) := by
  sorry

/- We admit that the above isomorphism is unique. -/
lemma orderIsoFin_unique (α : Type) [Fintype α] [LinearOrder α] (f : α ≃o Fin (Fintype.card α)) :
  f = orderIsoFin α := by
  sorry

/- We admit that the only order automorphism of `Fin n` is the identity. -/