import Mathlib

open Complex

theorem norm_sub_le_of_mem_sphere {c : ℂ} {R : ℝ} {D : ℂ} (hD : R < ‖D - c‖) {E : ℂ} (hE : ‖E - c‖ = R) :
    ‖D - c‖ - R ≤ ‖D - E‖ ∧ ‖D - E‖ ≤ ‖D - c‖ + R := by
  constructor
  · calc
      ‖D - c‖ - R = ‖D - c‖ - ‖E - c‖ := by rw [hE]
      _ ≤ ‖(D - c) - (E - c)‖ := norm_sub_norm_le _ _
      _ = ‖D - E‖ := by ring
  · calc
      ‖D - E‖ = ‖(D - c) - (E - c)‖ := by ring
      _ ≤ ‖D - c‖ + ‖E - c‖ := norm_sub_le _ _
      _ = ‖D - c‖ + R := by rw [hE]