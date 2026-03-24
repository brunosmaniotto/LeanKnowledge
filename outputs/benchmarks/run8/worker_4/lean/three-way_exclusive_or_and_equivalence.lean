import Mathlib

theorem triple_iff_xor (p q r : Prop) : ((p ↔ q) ↔ r) ↔ (Xor' (Xor' p q) r) := by
  classical
  by_cases hp : p
  · by_cases hq : q
    · by_cases hr : r
      · simp [hp, hq, hr, Xor']
      · simp [hp, hq, hr, Xor']
    · by_cases hr : r
      · simp [hp, hq, hr, Xor']
      · simp [hp, hq, hr, Xor']
  · by_cases hq : q
    · by_cases hr : r
      · simp [hp, hq, hr, Xor']
      · simp [hp, hq, hr, Xor']
    · by_cases hr : r
      · simp [hp, hq, hr, Xor']
      · simp [hp, hq, hr, Xor']