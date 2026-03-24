import Mathlib
open Topology

/-- Market demand depends on the distribution of income, not just the aggregate.
    We show this by constructing two income distributions with the same total
    but different market demands under a simple demand function. -/
theorem claim_4_1_b :
    ∃ (d : ℝ → ℝ) (w₁ w₂ w₁' w₂' : ℝ),
      w₁ + w₂ = w₁' + w₂' ∧
      d w₁ + d w₂ ≠ d w₁' + d w₂' := by
  -- Use d(w) = w^2 as a nonlinear demand function
  refine ⟨fun w => w ^ 2, 1, 3, 2, 2, by norm_num, by norm_num⟩