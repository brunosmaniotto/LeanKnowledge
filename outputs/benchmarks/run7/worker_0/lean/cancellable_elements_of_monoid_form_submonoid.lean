import Mathlib

variable (M : Type _) [Monoid M]

def cancellableSubmonoid : Submonoid M where
  carrier := { a | (∀ b c, a * b = a * c → b = c) ∧ (∀ b c, b * a = c * a → b = c) }
  one_mem' := by
    constructor <;> intro b c h <;> simpa using h
  mul_mem' := by
    rintro a b ⟨hla, hra⟩ ⟨hlb, hrb⟩
    constructor
    · intro x y h
      apply hlb
      apply hla
      rw [mul_assoc, mul_assoc] at h
      exact h
    · intro x y h
      apply hra
      apply hrb
      rw [← mul_assoc, ← mul_assoc] at h
      exact h