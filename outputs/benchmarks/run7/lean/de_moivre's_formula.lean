import Mathlib

theorem de_moivre_formula_nat (z : ℂ) (r x : ℝ) (n : ℕ) (h : z = (r : ℂ) * (Complex.cos x + Complex.I * Complex.sin x)) :
    z ^ n = (r : ℂ) ^ n * (Complex.cos (n * x) + Complex.I * Complex.sin (n * x)) := by
  rw [h, mul_pow]
  have base_eq : Complex.cos x + Complex.I * Complex.sin x = Complex.cos x + Complex.sin x * Complex.I := by ring
  rw [base_eq, Complex.cos_add_sin_mul_I_pow]
  congr 1
  push_cast
  ring