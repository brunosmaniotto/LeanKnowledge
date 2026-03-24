import Mathlib

theorem exists_floor_eq (x : ℝ) : ∃ (n : ℤ) (t : ℝ), t ∈ Set.Ico (0 : ℝ) 1 ∧ (x : ℝ) = (n : ℝ) + t ∧ n = Int.floor x := by
  exact ⟨Int.floor x, Int.fract x, ⟨Int.fract_nonneg x, Int.fract_lt_one x⟩, (Int.floor_add_fract x).symm, rfl⟩