import Mathlib

theorem ceil_sub_mem_Ico (x : ℝ) : (↑(Int.ceil x) : ℝ) - x ∈ Set.Ico (0 : ℝ) (1 : ℝ) := by
  have h_le : x ≤ (↑(Int.ceil x) : ℝ) := Int.le_ceil x
  have h_lt : (↑(Int.ceil x) : ℝ) < x + 1 := Int.ceil_lt_add_one x
  exact ⟨by linarith, by linarith⟩