import Mathlib

open Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

theorem chord_lies_inside_circle (c : E) (r : ℝ) (A B : E) (hA : ‖A - c‖ = r) (hB : ‖B - c‖ = r)
    (x : E) (hx : x ∈ segment ℝ A B) : ‖x - c‖ ≤ r := by
  rcases hx with ⟨a, b, ha, hb, hab, rfl⟩
  have h : a • A + b • B - c = a • (A - c) + b • (B - c) := by
    calc
      a • A + b • B - c = a • A + b • B - (a + b) • c := by rw [hab, one_smul]
      _ = a • A + b • B - (a • c + b • c) := by rw [add_smul]
      _ = (a • A - a • c) + (b • B - b • c) := by abel
      _ = a • (A - c) + b • (B - c) := by rw [smul_sub, smul_sub]
  rw [h]
  calc
    ‖a • (A - c) + b • (B - c)‖ ≤ ‖a • (A - c)‖ + ‖b • (B - c)‖ := norm_add_le _ _
    _ = ‖a‖ * ‖A - c‖ + ‖b‖ * ‖B - c‖ := by rw [norm_smul, norm_smul]
    _ = |a| * ‖A - c‖ + |b| * ‖B - c‖ := by simp [Real.norm_eq_abs]
    _ = |a| * r + |b| * r := by rw [hA, hB]
    _ = (|a| + |b|) * r := by ring
    _ = (a + b) * r := by rw [abs_of_nonneg ha, abs_of_nonneg hb]
    _ = 1 * r := by rw [hab]
    _ = r := by simp