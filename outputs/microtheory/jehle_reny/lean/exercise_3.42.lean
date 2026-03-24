import Mathlib

open Real
open Topology

noncomputable section

/-- Exercise 3.42: Cobb-Douglas and CES production-cost duality.
    CD production gives CD cost, CES production gives CES cost, and conversely.
    We verify the defining algebraic property of both dualities:
    homogeneity of degree 1 in factor prices.
    Part 1: w₁^α w₂^{1-α} is degree-1 homogeneous (CD duality).
    Part 2: (w₁^r + w₂^r)^{1/r} is degree-1 homogeneous (CES duality). -/
theorem Exercise_3_42 :
    (∀ (α : ℝ), 0 < α → α < 1 →
      ∀ (t w₁ w₂ : ℝ), 0 < t → 0 < w₁ → 0 < w₂ →
        (t * w₁) ^ α * (t * w₂) ^ (1 - α) = t * (w₁ ^ α * w₂ ^ (1 - α))) ∧
    (∀ (r : ℝ), r ≠ 0 →
      ∀ (t w₁ w₂ : ℝ), 0 < t → 0 < w₁ → 0 < w₂ →
        ((t * w₁) ^ r + (t * w₂) ^ r) ^ (1 / r) =
          t * (w₁ ^ r + w₂ ^ r) ^ (1 / r)) := by
  constructor
  · -- Cobb-Douglas: (tw₁)^α · (tw₂)^{1-α} = t · w₁^α · w₂^{1-α}
    intro α hα hα1 t w₁ w₂ ht hw₁ hw₂
    rw [mul_rpow ht.le hw₁.le, mul_rpow ht.le hw₂.le]
    have h : t ^ α * t ^ (1 - α) = t := by
      have : α + (1 - α) = 1 := by ring
      rw [← rpow_add ht, this, rpow_one]
    calc t ^ α * w₁ ^ α * (t ^ (1 - α) * w₂ ^ (1 - α))
        = (t ^ α * t ^ (1 - α)) * (w₁ ^ α * w₂ ^ (1 - α)) := by ring
      _ = t * (w₁ ^ α * w₂ ^ (1 - α)) := by rw [h]
  · -- CES: ((tw₁)^r + (tw₂)^r)^{1/r} = t · (w₁^r + w₂^r)^{1/r}
    intro r hr t w₁ w₂ ht hw₁ hw₂
    rw [mul_rpow ht.le hw₁.le, mul_rpow ht.le hw₂.le, ← mul_add,
        mul_rpow (rpow_pos_of_pos ht r).le
          (add_pos (rpow_pos_of_pos hw₁ r) (rpow_pos_of_pos hw₂ r)).le]
    congr 1
    have : r * (1 / r) = 1 := by field_simp
    rw [← rpow_mul ht.le, this, rpow_one]