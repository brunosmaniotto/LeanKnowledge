import Mathlib

instance induced_structure_abelian_group {G : Type*} [CommGroup G] (S : Type*) : CommGroup (S → G) :=
  inferInstance