import Mathlib

open Localization

variable {S : Type*} [CommMonoid S]
variable {T : Type*} [CommMonoid T]

/-- The submonoid of cancellative elements in a commutative monoid. -/
def cancellative : Submonoid S where
  carrier := {x | ∀ a b, x * a = x * b → a = b}
  one_mem' := by
    intro a b h
    simpa using h
  mul_mem' := by
    intro x y hx hy a b h
    apply hy
    apply hx
    rw [← mul_assoc, ← mul_assoc, h]