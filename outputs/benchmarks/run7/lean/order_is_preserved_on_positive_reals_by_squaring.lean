import Mathlib

theorem pos_imp_sq_lt_sq {x y : ℝ} (hx : 0 < x) (hy : 0 < y) : x < y ↔ x ^ 2 < y ^ 2 := by
  constructor
  · intro h
    calc
      x ^ 2 = x * x := by ring
      _ < x * y := mul_lt_mul_of_pos_left h hx
      _ < y * y := mul_lt_mul_of_pos_right h hy
      _ = y ^ 2 := by ring
  · intro h
    have h1 : y ^ 2 - x ^ 2 = (y - x) * (y + x) := by ring
    have h2 : 0 < y + x := by linarith
    have h3 : 0 < y ^ 2 - x ^ 2 := by linarith
    have h4 : 0 < y - x := by
      contrapose! h3
      -- Now `h4 : y - x ≤ 0`
      have : (y - x) * (y + x) ≤ 0 := mul_nonpos_of_nonpos_of_nonneg h3 (by linarith)
      linarith
    linarith