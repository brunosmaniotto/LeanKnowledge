import Mathlib
open BigOperators

/-- A linear social welfare function W(u₁,...,uᵢ) = Σᵢ λᵢ uᵢ with λ ≥ 0. -/
structure LinearSWF (I : ℕ) where
  /-- The weights λ₁, ..., λ_I -/
  weights : Fin I → ℝ
  /-- All weights are non-negative -/
  weights_nonneg : ∀ i, 0 ≤ weights i

namespace LinearSWF

/-- Evaluate the linear SWF on a utility vector. -/
noncomputable def eval {I : ℕ} (W : LinearSWF I) (u : Fin I → ℝ) : ℝ :=
  ∑ i, W.weights i * u i

end LinearSWF