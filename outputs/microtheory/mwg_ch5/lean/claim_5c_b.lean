import Mathlib
open Topology

/-- For constant-returns technology y₂ = y₁ (one unit of input produces one unit of output),
    profit is (p₂ - p₁) · y₂. When p₁ ≥ p₂, optimal profit is 0.
    When p₂ > p₁, profit is unbounded. -/
theorem constant_returns_profit (p₁ p₂ : ℝ) :
    (p₁ ≥ p₂ → ∀ y : ℝ, 0 ≤ y → (p₂ - p₁) * y ≤ 0) ∧
    (p₁ ≥ p₂ → (p₂ - p₁) * 0 = 0) ∧
    (p₂ > p₁ → ∀ M : ℝ, ∃ y : ℝ, 0 ≤ y ∧ (p₂ - p₁) * y > M) := by
  refine ⟨fun h y hy => ?_, fun _ => by ring, fun h M => ?_⟩
  · nlinarith
  · have hd : p₂ - p₁ > 0 := by linarith
    by_cases hM : M ≤ 0
    · exact ⟨1, zero_le_one, by nlinarith⟩
    · push_neg at hM
      refine ⟨M / (p₂ - p₁) + 1, ?_, ?_⟩
      · have : 0 ≤ M / (p₂ - p₁) := div_nonneg (le_of_lt hM) (le_of_lt hd)
        linarith
      · have hdiv : M / (p₂ - p₁) * (p₂ - p₁) = M := div_mul_cancel₀ M (ne_of_gt hd)
        nlinarith