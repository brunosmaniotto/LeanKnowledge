import Mathlib

open Real
set_option linter.unusedVariables false

theorem Claim_7_4_Fig728 (α β γ : ℝ) (hα : 0 < α) (hβ : 0 < β) (hγ : 0 < γ) (hsum : α + β + γ = 1)
    (hr1 : α / β = 3) (hr2 : β / γ = 1/5) (hr3 : γ / α = 5/3) : (α, β, γ) = (1/3, 1/9, 5/9) := by
  -- From α/β = 3, we get α = 3β
  have h1 : α = 3 * β := by
    rw [div_eq_iff (ne_of_gt hβ)] at hr1
    exact hr1
  -- From β/γ = 1/5, we get γ = 5β
  have h2 : γ = 5 * β := by
    rw [div_eq_iff (ne_of_gt hγ)] at hr2
    linarith [hr2]
  -- Substitute into the sum to solve for β
  rw [h1, h2] at hsum
  have hβ_val : β = 1/9 := by linarith
  -- Compute α and γ from β
  have hα_val : α = 1/3 := by rw [hβ_val] at h1; linarith
  have hγ_val : γ = 5/9 := by rw [hβ_val] at h2; linarith
  -- Prove the tuple equality
  simp [hα_val, hβ_val, hγ_val]