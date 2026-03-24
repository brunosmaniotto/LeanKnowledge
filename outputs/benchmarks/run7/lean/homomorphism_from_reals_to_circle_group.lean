import Mathlib

noncomputable def φ : ℝ → ℂ := fun x => Complex.exp (Complex.I * x)

theorem φ_hom (x y : ℝ) : φ (x + y) = φ x * φ y := by
  dsimp [φ]
  push_cast
  rw [mul_add, Complex.exp_add]