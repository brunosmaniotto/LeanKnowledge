import Mathlib

-- Basic fact: 10 ≡ 1 (mod 9)
lemma ten_mod_nine : Nat.ModEq 9 10 1 := by
  norm_num

-- Powers of 10 are all ≡ 1 (mod 9)