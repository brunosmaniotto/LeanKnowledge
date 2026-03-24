import Mathlib

theorem Exercise_4_22_a (α β c F : ℝ) (hβ : 0 < β) (hαc : c < α)
    (hF : (α - c) ^ 2 > 4 * β * F) :
    let q_m := (α - c) / (2 * β)
    let p_m := α - β * q_m
    let π_m := p_m * q_m - (c * q_m + F)
    p_m = (α + c) / 2 ∧ π_m = (α - c) ^ 2 / (4 * β) - F := by
  refine ⟨?_, ?_⟩
  · dsimp only
    have hβ' : (2 : ℝ) * β ≠ 0 := by positivity
    field_simp
    ring
  · dsimp only
    have hβ' : (2 : ℝ) * β ≠ 0 := by positivity
    field_simp
    ring