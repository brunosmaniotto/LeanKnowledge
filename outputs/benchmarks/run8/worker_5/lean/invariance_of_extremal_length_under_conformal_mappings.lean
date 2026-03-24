import Mathlib

open Complex

theorem Gamma_three : Gamma (3 : ℂ) = 2 := by
  have h1 : Gamma (1 : ℂ) = 1 := Gamma_one
  have h2 : Gamma (2 : ℂ) = 1 := by
    calc
      Gamma (2 : ℂ) = Gamma ((1 : ℂ) + 1) := by norm_num
      _ = (1 : ℂ) * Gamma (1 : ℂ) := by rw [Gamma_add_one (1 : ℂ) (by norm_num : (1 : ℂ) ≠ 0)]
      _ = 1 * 1 := by rw [h1]
      _ = 1 := by norm_num
  calc
    Gamma (3 : ℂ) = Gamma ((2 : ℂ) + 1) := by norm_num
    _ = (2 : ℂ) * Gamma (2 : ℂ) := by rw [Gamma_add_one (2 : ℂ) (by norm_num : (2 : ℂ) ≠ 0)]
    _ = (2 : ℂ) * 1 := by rw [h2]
    _ = 2 := by norm_num