import Mathlib

open Classical

variable {R : Type} [Ring R] [Nontrivial R]

theorem zero_divisor_iff_not_cancellable (z : R) (hz : z ≠ 0) :
    (∃ x, x ≠ 0 ∧ (z * x = 0 ∨ x * z = 0)) ↔
    ¬ (∀ x y, z * x = z * y → x = y) ∨ ¬ (∀ x y, x * z = y * z → x = y) := by
  constructor
  · intro h
    rcases h with ⟨x, hx, hxz⟩
    cases' hxz with hleft hright
    · left
      intro hc
      apply hx
      apply hc
      rw [hleft, mul_zero]
    · right
      intro hc
      apply hx
      apply hc
      rw [hright, zero_mul]
  · intro h
    cases' h with hleft hright
    · push_neg at hleft
      rcases hleft with ⟨x, y, h_eq, h_ne⟩
      refine ⟨x - y, sub_ne_zero.mpr h_ne, Or.inl ?_⟩
      rw [mul_sub, h_eq, sub_self]
    · push_neg at hright
      rcases hright with ⟨x, y, h_eq, h_ne⟩
      refine ⟨x - y, sub_ne_zero.mpr h_ne, Or.inr ?_⟩
      rw [sub_mul, h_eq, sub_self]