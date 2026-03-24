import Mathlib
open Topology

theorem Example_3_2
    (α β k y : ℝ)
    (hk : 0 < k)
    (hy₀ : 0 < y)
    (hy₁ : y < k) :
    α * (1 - y / k) = α * (k - y) / k ∧
    β * (1 - y / k) = β * (k - y) / k ∧
    (α + β) * (1 - y / k) = (α + β) * (k - y) / k ∧
    (1 + (k / y - 1))⁻¹ * (k / y - 1) = 1 - y / k := by
  have hk' : k ≠ 0 := ne_of_gt hk
  have hy' : y ≠ 0 := ne_of_gt hy₀
  refine ⟨by field_simp, by field_simp, by field_simp, ?_⟩
  have h : 1 + (k / y - 1) = k / y := by ring
  rw [h]
  have hky : k / y ≠ 0 := div_ne_zero hk' hy'
  field_simp