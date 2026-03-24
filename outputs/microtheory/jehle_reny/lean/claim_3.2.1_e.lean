import Mathlib

theorem Claim_3_2_1_e (α β k : ℝ) (hα : 0 < α) (hβ : 0 < β) (hk : 0 < k)
    (hab : 1 < α + β) :
    ((α + β) * (1 - 0 / k) = α + β) ∧
    ((α + β) * (1 - k / k) = 0) ∧
    ((α + β) * (1 - k * (1 - 1 / (α + β)) / k) = 1) ∧
    (∀ y, 0 ≤ y → y < k * (1 - 1 / (α + β)) →
      (α + β) * (1 - y / k) > 1) ∧
    (∀ y, k * (1 - 1 / (α + β)) < y → y < k →
      (α + β) * (1 - y / k) < 1) := by
  have hk' : k ≠ 0 := hk.ne'
  have hab_pos : (0 : ℝ) < α + β := by linarith
  have hab' : α + β ≠ 0 := hab_pos.ne'
  refine ⟨by simp, ?_, ?_, ?_, ?_⟩
  · rw [div_self hk', sub_self, mul_zero]
  · field_simp <;> ring
  · intro y _ hlt
    rw [gt_iff_lt, ← sub_pos]
    have heq : (α + β) * (1 - y / k) - 1 = ((α + β) * k - (α + β) * y - k) / k := by
      field_simp <;> ring
    rw [heq]
    apply div_pos _ hk
    have h1 : y * (α + β) < k * (1 - 1 / (α + β)) * (α + β) :=
      mul_lt_mul_of_pos_right hlt hab_pos
    have h2 : k * (1 - 1 / (α + β)) * (α + β) = (α + β) * k - k := by
      field_simp <;> ring
    nlinarith
  · intro y hgt hyk
    rw [← sub_pos]
    have heq : 1 - (α + β) * (1 - y / k) = ((α + β) * y - (α + β) * k + k) / k := by
      field_simp <;> ring
    rw [heq]
    apply div_pos _ hk
    have h1 : k * (1 - 1 / (α + β)) * (α + β) < y * (α + β) :=
      mul_lt_mul_of_pos_right hgt hab_pos
    have h2 : k * (1 - 1 / (α + β)) * (α + β) = (α + β) * k - k := by
      field_simp <;> ring
    nlinarith