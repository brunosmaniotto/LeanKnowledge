import Mathlib

theorem integer_is_congruent_modulo_divisor_to_remainder (a m r : ℤ) (h_rem : ∃ q : ℤ, a = q * m + r) :
    a ≡ r [ZMOD m] := by
  rcases h_rem with ⟨q, h_eq⟩
  rw [Int.modEq_iff_dvd]
  use -q
  linarith