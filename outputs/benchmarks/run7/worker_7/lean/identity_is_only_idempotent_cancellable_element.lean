import Mathlib

variable {S : Type} [MulOneClass S]

theorem identity_is_only_idempotent_cancellative_element (x : S)
    (hidem : x * x = x) (hleft : ∀ a b, x * a = x * b → a = b) : x = 1 := by
  have h1 : x * x = x * 1 := by
    rw [hidem, mul_one]
  exact hleft x 1 h1