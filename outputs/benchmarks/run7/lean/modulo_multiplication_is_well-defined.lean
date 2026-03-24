import Mathlib

theorem mod_mul_well_defined {m a b x y : ℤ} (h1 : a ≡ b [ZMOD m]) (h2 : x ≡ y [ZMOD m]) :
    a * x ≡ b * y [ZMOD m] :=
  Int.ModEq.mul h1 h2