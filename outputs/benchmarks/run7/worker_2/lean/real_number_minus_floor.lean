import Mathlib

theorem sub_floor_mem_Ico (x : ℝ) : x - (Int.floor x : ℝ) ∈ Set.Ico (0 : ℝ) 1 := by
  constructor
  · exact sub_nonneg.mpr (Int.floor_le x)
  · linarith [Int.lt_floor_add_one x]