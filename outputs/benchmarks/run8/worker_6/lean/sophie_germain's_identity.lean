import Mathlib.Tactic

theorem sophie_germain_identity {R} [CommRing R] (x y : R) :
    x ^ 4 + 4 * y ^ 4 = (x ^ 2 + 2 * y ^ 2 + 2 * x * y) * (x ^ 2 + 2 * y ^ 2 - 2 * x * y) := by
  ring