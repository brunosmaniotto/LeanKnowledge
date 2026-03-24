import Mathlib

/-- When aggregate wealth compensation (w' = p' · x(p,w)) holds but individual
    compensation fails (αᵢ w' ≠ p' · xᵢ(p, αᵢ w)), the compensated law of
    demand can fail in aggregate. We formalize this as: there exist wealth
    shares α₁, α₂ summing to 1, and an aggregate wealth change w', such that
    the aggregate is compensated but at least one individual is not. -/
theorem aggregate_compensation_not_individual :
    ∃ (α₁ α₂ : ℝ) (w' v₁ v₂ v : ℝ),
      α₁ + α₂ = 1 ∧
      α₁ > 0 ∧ α₂ > 0 ∧
      -- aggregate compensation holds: w' = v (value of old bundle at new prices)
      w' = v ∧
      -- but individual compensations fail: αᵢ * w' ≠ vᵢ for at least one i
      (α₁ * w' ≠ v₁ ∨ α₂ * w' ≠ v₂) ∧
      -- where v₁ + v₂ = v (individual values sum to aggregate)
      v₁ + v₂ = v := by
  refine ⟨1/3, 2/3, 6, 1, 5, 6, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · norm_num
  · norm_num
  · norm_num
  · norm_num
  · left; norm_num
  · norm_num