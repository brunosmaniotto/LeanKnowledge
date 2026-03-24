import Mathlib

instance {S T : Type} [Semigroup S] [Semigroup T] : Semigroup (S × T) where
  mul a b := (a.1 * b.1, a.2 * b.2)
  mul_assoc a b c := by
    ext <;> simp [mul_assoc]