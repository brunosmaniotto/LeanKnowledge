import Mathlib

theorem homogeneous_level_set_preservation
    {N : ℕ} {r : ℤ} (f : (Fin N → ℝ) → ℝ)
    (hf : ∀ (t : ℝ), 0 < t → ∀ (x : Fin N → ℝ), f (fun i => t * x i) = t ^ r * f x)
    (x x' : Fin N → ℝ) (heq : f x = f x')
    (t : ℝ) (ht : 0 < t) :
    f (fun i => t * x i) = f (fun i => t * x' i) := by
  rw [hf t ht x, hf t ht x', heq]