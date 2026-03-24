import Mathlib
open Matrix

theorem Proposition_17_G_1 {n : ℕ}
    (B : Matrix (Fin n) (Fin n) ℝ) (hB : B.det ≠ 0) :
    ∃ (A₁ C A_rest : Matrix (Fin n) (Fin n) ℝ),
      IsUnit C.det ∧ A_rest = -C * B - A₁ ∧ -(C⁻¹ * (A₁ + A_rest)) = B := by
  refine ⟨0, 1, -B, ?_, ?_, ?_⟩
  · rw [det_one]; exact isUnit_one
  · simp [neg_mul]
  · simp