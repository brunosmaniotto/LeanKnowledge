import Mathlib

open CharP

theorem field_char_is_zero_or_prime (F : Type) [Field F] : ∃ (p : ℕ), CharP F p ∧ (p = 0 ∨ Nat.Prime p) := by
  obtain ⟨p, hcharp⟩ := CharP.exists F
  have h := CharP.char_is_prime_or_zero F p
  exact ⟨p, hcharp, h.symm⟩