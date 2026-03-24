import Mathlib

open Complex

theorem complex_definition : (∀ (x : ℝ), (x : ℂ) = ⟨x, 0⟩) ∧ (I = ⟨0, 1⟩) ∧ (∀ (x y : ℝ), (x : ℂ) + I * (y : ℂ) = ⟨x, y⟩) ∧ I ^ 2 = -1 := by
  have h1 : ∀ (x : ℝ), (x : ℂ) = ⟨x, 0⟩ := fun _ => rfl
  have h2 : I = ⟨0, 1⟩ := rfl
  have h3 : ∀ (x y : ℝ), (x : ℂ) + I * (y : ℂ) = ⟨x, y⟩ := by
    intro x y
    apply Complex.ext
    · simp [add_re, mul_re, ofReal_re, ofReal_im, I_re, I_im]
    · simp [add_im, mul_im, ofReal_re, ofReal_im, I_re, I_im]
  have h4 : I ^ 2 = -1 := Complex.I_sq
  exact ⟨h1, h2, h3, h4⟩