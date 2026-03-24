import Mathlib

/-- Cost-of-Adjustment Model (MWG Example 20.C.2). -/
structure CostOfAdjustmentModel where
  /-- Production function: F(k, l) gives output from capacity k and labor l. -/
  F : ℝ → ℝ → ℝ
  /-- Adjustment cost function γ. -/
  γ : ℝ → ℝ
  γ_convex : ConvexOn ℝ Set.univ γ
  γ_nonpos : ∀ z, z ≤ 0 → γ z = 0
  γ_pos : ∀ z, 0 < z → 0 < γ z

/-- The production set Y = {((-k,0,-l),(k',x,0)) : k≥0, l≥0, k'≥0,
    x ≤ F(k,l) - k' - γ(k'-k)} − ℝ⁶₊.
    Components: (capacity_in, consumption_in, labor_in,
                 capacity_out, consumption_out, labor_out). -/
noncomputable def CostOfAdjustmentModel.productionSet
    (m : CostOfAdjustmentModel) : Set (ℝ × ℝ × ℝ × ℝ × ℝ × ℝ) :=
  {y | ∃ (k l k' x : ℝ) (d₁ d₂ d₃ d₄ d₅ d₆ : ℝ),
    0 ≤ k ∧ 0 ≤ l ∧ 0 ≤ k' ∧
    x ≤ m.F k l - k' - m.γ (k' - k) ∧
    0 ≤ d₁ ∧ 0 ≤ d₂ ∧ 0 ≤ d₃ ∧ 0 ≤ d₄ ∧ 0 ≤ d₅ ∧ 0 ≤ d₆ ∧
    y = (-k - d₁, -d₂, -l - d₃, k' - d₄, x - d₅, -d₆)}