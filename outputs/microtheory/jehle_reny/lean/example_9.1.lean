import Mathlib

theorem Example_9_1 (v : ℝ) {N : ℕ} (hN : N ≠ 0) :
    v - v / (N : ℝ) = v * ((↑N - 1) / ↑N) := by
  field_simp