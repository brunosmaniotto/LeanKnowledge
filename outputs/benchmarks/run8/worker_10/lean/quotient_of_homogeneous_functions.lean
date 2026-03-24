import Mathlib

variable {E : Type _} [AddCommMonoid E] [Module ℝ E]

theorem homogeneous_quotient (M N : E → ℝ) (n : ℕ)
    (hM : ∀ (t : ℝ) (x : E), M (t • x) = t ^ n * M x)
    (hN : ∀ (t : ℝ) (x : E), N (t • x) = t ^ n * N x)
    (x : E) (t : ℝ) (ht : t ≠ 0) : M (t • x) / N (t • x) = M x / N x := by
  by_cases hNx : N x = 0
  · simp [hM, hN, hNx, div_zero]
  · rw [hM, hN]
    field_simp [pow_ne_zero n ht, hNx]