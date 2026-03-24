import Mathlib

open Additive

variable {G : Type*} [Group G] (g : G)

/-- The additive group homomorphism from ℤ to `Additive G` sending n to `g ^ n`. -/
def ψ : ℤ →+ Additive G where
  toFun n := ofMul (g ^ n)
  map_zero' := by simp
  map_add' m n := by simp [zpow_add]