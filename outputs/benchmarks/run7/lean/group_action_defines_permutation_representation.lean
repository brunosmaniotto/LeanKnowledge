import Mathlib.GroupTheory.GroupAction.Basic

variable {G X : Type*} [Group G] [MulAction G X]

open MulAction

/-- The permutation representation induced by a group action. -/
def tilde_phi : G →* Equiv.Perm X :=
  { toFun := toPerm
    map_one' := by
      ext x
      simp [toPerm]
    map_mul' := by
      intro g h
      ext x
      simp [toPerm, mul_smul] }