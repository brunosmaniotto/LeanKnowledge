import Mathlib

theorem congruence_by_divisor_of_modulus (a b z m : ℝ) 
    (hz : ∃ (k : ℤ), z = (k : ℝ) * m) 
    (hmod : ∃ (w : ℤ), a - b = (w : ℝ) * z) : 
    ∃ (w' : ℤ), a - b = (w' : ℝ) * m := by
  rcases hz with ⟨k, hz⟩
  rcases hmod with ⟨w, hw⟩
  refine ⟨w * k, ?_⟩
  rw [hz] at hw
  have : (w : ℝ) * ((k : ℝ) * m) = ((w * k : ℤ) : ℝ) * m := by
    push_cast
    ring
  rw [this] at hw
  exact hw