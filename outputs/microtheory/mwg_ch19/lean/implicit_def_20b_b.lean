import Mathlib

/-- The T-period backward shift of a consumption stream.
    Given c = (c_0, c_1, ...), the shift c^T is defined by c^T_t = c_{t+T}. -/
def backwardShift (c : ℕ → ℝ) (T : ℕ) : ℕ → ℝ :=
  fun t => c (t + T)