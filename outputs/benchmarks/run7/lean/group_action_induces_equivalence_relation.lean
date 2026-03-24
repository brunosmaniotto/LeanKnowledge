import Mathlib.GroupTheory.GroupAction.Basic

open MulAction Set

variable {G X : Type*} [Group G] [MulAction G X]

/-- The relation induced by a group action: `x` is related to `y` if `y` is in the orbit of `x`. -/
def R (x y : X) : Prop := y ∈ orbit G x