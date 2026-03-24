import Mathlib

open Set
open scoped Pointwise

variable {S : Type} [Semigroup S]

theorem set_mul_assoc (A B C : Set S) : A * (B * C) = (A * B) * C := by
  ext x
  constructor
  · intro hx
    rcases hx with ⟨a, ha, bc, hbc, rfl⟩
    rcases hbc with ⟨b, hb, c, hc, rfl⟩
    exact ⟨a * b, ⟨a, ha, b, hb, rfl⟩, c, hc, mul_assoc a b c⟩
  · intro hx
    rcases hx with ⟨ab, hab, c, hc, rfl⟩
    rcases hab with ⟨a, ha, b, hb, rfl⟩
    exact ⟨a, ha, b * c, ⟨b, hb, c, hc, rfl⟩, (mul_assoc a b c).symm⟩