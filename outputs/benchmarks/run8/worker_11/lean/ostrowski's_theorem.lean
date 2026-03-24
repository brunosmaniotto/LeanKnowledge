import Mathlib

theorem ostrowski_theorem (f : AbsoluteValue ℚ ℝ) (h : ∃ n : ℕ, 1 < n ∧ f n ≠ 1) :
    (∃ (C : ℝ) (hC : C > 0), ∀ x : ℚ, f x = |x| ^ C) ∨
    ∃ (p : ℕ) (hp : p.Prime), ∃ (C : ℝ) (hC : C > 0), ∀ x : ℚ, f x = (padicNorm p x : ℝ) ^ C := by
  sorry