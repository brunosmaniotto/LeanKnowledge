import Mathlib

instance GroupActionOnSubgroupOfSymmetricGroup (X : Type u) (H : Subgroup (Equiv.Perm X)) : MulAction H X :=
  H.mulAction