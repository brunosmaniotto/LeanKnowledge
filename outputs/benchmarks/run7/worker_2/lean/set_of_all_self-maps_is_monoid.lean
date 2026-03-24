import Mathlib

universe u

instance (S : Type u) : Monoid (S → S) where
  mul f g := f ∘ g
  one := id
  mul_assoc _ _ _ := rfl
  one_mul _ := rfl
  mul_one _ := rfl