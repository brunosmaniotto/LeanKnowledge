import Mathlib

theorem homogeneous_level_set_preservation
    {N : ℕ} {r : ℝ} (f : (Fin N → ℝ) → ℝ)
    (hf : ∀ (t : ℝ), 0 < t → ∀ (x : Fin N → ℝ), f (t • x) = t ^ r * f x)
    (x x' : Fin N → ℝ) (heq : f x = f x')
    (t : ℝ) (ht : 0 < t) :
    f (t • x) = f (t • x') := by
  rw [hf t ht x, hf t ht x', heq]