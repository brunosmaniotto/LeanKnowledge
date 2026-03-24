import Mathlib

open ContinuousMap

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y] (K : Set X)

theorem Relative_Homotopy_is_Equivalence_Relation :
    Equivalence (fun (f g : C(X, Y)) => HomotopicRel f g K) where
  refl f := HomotopicRel.refl f
  symm h := HomotopicRel.symm h
  trans h1 h2 := HomotopicRel.trans h1 h2