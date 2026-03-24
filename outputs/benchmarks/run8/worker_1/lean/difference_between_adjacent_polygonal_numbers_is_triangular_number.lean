import Mathlib

noncomputable def polygonal (k n : ℚ) : ℚ := n / 2 * (((k : ℚ) - 2) * n - k + 4)

def triangular (n : ℕ) : ℕ := n * (n + 1) / 2