import Mathlib

open Set
open SimpleGraph

variable {V : Type*} (G : SimpleGraph V)

theorem Graph_Components_are_Equivalence_Classes :
    Set.range (fun (v : V) => {w | G.Reachable w v}) = Setoid.classes G.reachableSetoid := by
  ext s
  constructor
  · rintro ⟨v, rfl⟩
    exact ⟨v, rfl⟩
  · rintro ⟨v, rfl⟩
    exact ⟨v, rfl⟩