import Mathlib
open Finset

axiom Unique_Isomorphism_Finite_Totally_Ordered {α β : Type} [LinearOrder α] [LinearOrder β] [Fintype α] [Fintype β]
    (hcard : Fintype.card α = Fintype.card β) : ∃! f : α ≃o β, True

axiom Equivalence_Mappings_Same_Cardinality {α β : Type} [Fintype α] [Fintype β] (hcard : Fintype.card α = Fintype.card β)
    (f : α → β) (hinj : Function.Injective f) : Function.Bijective f

def interval (m n : ℕ) : Type := {x : ℕ // x ∈ Icc (m + 1) n}

namespace interval

instance (m n : ℕ) : LinearOrder (interval m n) := by
  unfold interval
  exact inferInstance

instance (m n : ℕ) : Fintype (interval m n) := by
  unfold interval
  exact inferInstance