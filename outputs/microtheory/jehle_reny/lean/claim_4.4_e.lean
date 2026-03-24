import Mathlib
open Topology

theorem Claim_4_4_e (a c b : ℝ) (ha : a > c) (hb : b > 0) :
    (∀ J : ℕ, (a - c) ^ 2 / (((↑J : ℝ) + 2) ^ 2 * (2 * b)) ≤
              (a - c) ^ 2 / (((↑J : ℝ) + 1) ^ 2 * (2 * b))) ∧
    (∀ ε : ℝ, ε > 0 → ∃ N : ℕ, ∀ J : ℕ, J ≥ N →
      (a - c) ^ 2 / (((↑J : ℝ) + 1) ^ 2 * (2 * b)) < ε) := by
  constructor
  · intro J
    have hd1 : (0 : ℝ) < ((↑J : ℝ) + 1) ^ 2 * (2 * b) := by positivity
    have hd2 : (0 : ℝ) < ((↑J : ℝ) + 2) ^ 2 * (2 * b) := by positivity
    suffices h : 0 ≤ (a - c) ^ 2 / (((↑J : ℝ) + 1) ^ 2 * (2 * b)) -
                     (a - c) ^ 2 / (((↑J : ℝ) + 2) ^ 2 * (2 * b)) by linarith
    rw [div_sub_div _ _ hd1.ne' hd2.ne']
    apply div_nonneg
    · have hle : ((↑J : ℝ) + 1) ^ 2 * (2 * b) ≤ ((↑J : ℝ) + 2) ^ 2 * (2 * b) := by
        nlinarith [Nat.cast_nonneg (α := ℝ) J]
      nlinarith [sq_nonneg (a - c)]
    · positivity
  · intro ε hε
    obtain ⟨N, hN⟩ := exists_nat_gt ((a - c) ^ 2 / (2 * b * ε))
    exact ⟨N, fun J hJ => by
      have hden : (0 : ℝ) < ((↑J : ℝ) + 1) ^ 2 * (2 * b) := by positivity
      have h2bε : (0 : ℝ) < 2 * b * ε := by positivity
      have hNJ : (↑N : ℝ) ≤ ↑J := Nat.cast_le.mpr hJ
      have hsq : (↑J : ℝ) + 1 ≤ ((↑J : ℝ) + 1) ^ 2 := by
        nlinarith [Nat.cast_nonneg (α := ℝ) J]
      have hbd : (a - c) ^ 2 / (2 * b * ε) < ((↑J : ℝ) + 1) ^ 2 := by linarith
      have hkey : (a - c) ^ 2 < ((↑J : ℝ) + 1) ^ 2 * (2 * b) * ε := by
        have hmul := mul_lt_mul_of_pos_right hbd h2bε
        have hcancel : (a - c) ^ 2 / (2 * b * ε) * (2 * b * ε) = (a - c) ^ 2 := by
          field_simp
        linarith [show ((↑J : ℝ) + 1) ^ 2 * (2 * b * ε) =
                       ((↑J : ℝ) + 1) ^ 2 * (2 * b) * ε by ring]
      show (a - c) ^ 2 * (((↑J : ℝ) + 1) ^ 2 * (2 * b))⁻¹ < ε
      have hdinv : (0 : ℝ) < (((↑J : ℝ) + 1) ^ 2 * (2 * b))⁻¹ := by positivity
      calc (a - c) ^ 2 * (((↑J : ℝ) + 1) ^ 2 * (2 * b))⁻¹
          < ((↑J : ℝ) + 1) ^ 2 * (2 * b) * ε * (((↑J : ℝ) + 1) ^ 2 * (2 * b))⁻¹ :=
            mul_lt_mul_of_pos_right hkey hdinv
        _ = ε := by field_simp⟩