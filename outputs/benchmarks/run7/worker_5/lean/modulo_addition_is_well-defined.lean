import Mathlib

theorem mod_add_well_defined (m : ℤ) (a b x y : ℤ) (h1 : a ≡ b [ZMOD m]) (h2 : x ≡ y [ZMOD m]) :
    a + x ≡ b + y [ZMOD m] := by
  have h1' : m ∣ b - a := Int.modEq_iff_dvd.1 h1
  have h2' : m ∣ y - x := Int.modEq_iff_dvd.1 h2
  rw [Int.modEq_iff_dvd]
  have : (b + y) - (a + x) = (b - a) + (y - x) := by ring
  rw [this]
  exact Int.dvd_add h1' h2'