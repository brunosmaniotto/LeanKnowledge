import Mathlib
open Topology

/-- The production possibility set: nonneg output pairs (q₁, q₂) producible
    from factor endowments, given production functions for two goods.
    `f₁` and `f₂` map factor allocations (vectors in ℝⁿ) to output quantities.
    `endowment` is the economy's total factor vector.
    An output pair is feasible if there exist factor allocations summing
    to at most the endowment that produce those outputs. -/
noncomputable def ProductionPossibilitySet
    {n : ℕ}
    (f₁ f₂ : (Fin n → ℝ) → ℝ)
    (endowment : Fin n → ℝ) : Set (ℝ × ℝ) :=
  { q : ℝ × ℝ |
    0 ≤ q.1 ∧ 0 ≤ q.2 ∧
    ∃ z₁ z₂ : Fin n → ℝ,
      (∀ i, 0 ≤ z₁ i) ∧
      (∀ i, 0 ≤ z₂ i) ∧
      (∀ i, z₁ i + z₂ i ≤ endowment i) ∧
      f₁ z₁ ≥ q.1 ∧
      f₂ z₂ ≥ q.2 }