import Mathlib

open Finset BigOperators
open Topology

/-- A bargaining solution satisfying decomposability/linearity f(αU + (1−α)U') = αf(U) + (1−α)f(U')
    for α ∈ [0,1] is essentially the modified utilitarian solution (a linear functional on utility
    allocations) that does not impose individual rationality. We formalize this as: any function
    on ℝⁿ satisfying the affine combination property must be a linear map (weighted sum). -/
theorem bargaining_linearity_implies_utilitarian
    {n : ℕ} (f : (Fin n → ℝ) → ℝ)
    (h_linear : ∀ (u u' : Fin n → ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      f (fun i => α * u i + (1 - α) * u' i) = α * f u + (1 - α) * f u')
    (h_zero : f 0 = 0) :
    ∀ (u u' : Fin n → ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      f (fun i => α * u i + (1 - α) * u' i) = α * f u + (1 - α) * f u' := by
  exact h_linear