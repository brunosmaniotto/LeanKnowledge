import Mathlib
open Topology

/-- Claim A2 (MWG): The curvature of the objective function along a constraint
    is governed by the bordered Hessian. Given d²y/dx₁² · g₂² = -D̄
    (equivalently d²y/dx₁² = -D̄/g₂²), the sign of d²y/dx₁² is opposite to D̄. -/
theorem claim_A2_CurvatureViaBorderedHessian
    (g₂ : ℝ) (hg₂ : g₂ ≠ 0)
    (d2y D_bar : ℝ)
    (h_formula : d2y * g₂ ^ 2 = -D_bar) :
    (d2y > 0 ↔ D_bar < 0) ∧ (d2y < 0 ↔ D_bar > 0) := by
  have hg₂sq : (0 : ℝ) < g₂ ^ 2 := by positivity
  refine ⟨⟨fun h => ?_, fun h => ?_⟩, ⟨fun h => ?_, fun h => ?_⟩⟩
  · nlinarith [mul_pos h hg₂sq]
  · by_contra h'; push_neg at h'
    nlinarith [mul_nonpos_of_nonpos_of_nonneg h' hg₂sq.le]
  · nlinarith [mul_neg_of_neg_of_pos h hg₂sq]
  · by_contra h'; push_neg at h'
    nlinarith [mul_nonneg h' hg₂sq.le]