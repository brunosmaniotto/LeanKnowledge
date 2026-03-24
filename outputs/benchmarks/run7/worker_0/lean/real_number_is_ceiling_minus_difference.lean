import Mathlib

open Set

theorem exists_t_in_Ico_zero_one_eq_sub_iff_ceil_eq (x : ℝ) (n : ℤ) :
    (∃ t, t ∈ Ico (0 : ℝ) 1 ∧ x = (n : ℝ) - t) ↔ Int.ceil x = n := by
  constructor
  · intro ⟨t, ⟨ht_left, ht_right⟩, hx⟩
    have h_le : x ≤ (n : ℝ) := by
      rw [hx]
      linarith
    have h_lt : (n : ℝ) - 1 < x := by
      rw [hx]
      linarith
    rw [Int.ceil_eq_iff]
    exact ⟨h_lt, h_le⟩
  · intro h
    rcases Int.ceil_eq_iff.mp h with ⟨h_lt, h_le⟩
    refine ⟨(n : ℝ) - x, ⟨by linarith, by linarith⟩, ?_⟩
    ring