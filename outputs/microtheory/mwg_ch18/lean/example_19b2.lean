import Mathlib

/-- A production plan in the two-state (good/bad weather), two-commodity (seeds/crops) model.
    Components: (seeds_good, crops_good, seeds_bad, crops_bad).
    Feasibility requires:
    1. Seeds planted before weather is known, so input must be same in both states: y₁₁ = y₁₂
    2. Seeds are inputs (non-positive): y₁₁ ≤ 0
    3. In good weather, crops produced ≤ seeds planted: y₂₁ ≤ -y₁₁
    4. In bad weather, no crops produced: y₂₂ ≤ 0
    5. Crops are non-negative: y₂₁ ≥ 0 ∧ y₂₂ ≥ 0 -/
def Example_19B2_feasible (y₁₁ y₂₁ y₁₂ y₂₂ : ℝ) : Prop :=
  y₁₁ = y₁₂ ∧ y₁₁ ≤ 0 ∧ y₂₁ ≤ -y₁₁ ∧ y₂₁ ≥ 0 ∧ y₂₂ ≤ 0 ∧ y₂₂ ≥ 0