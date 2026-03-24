import Mathlib

/-- Ramsey-Solow Model with production function F(k, l). -/
structure RamseySolowModel where
  F : ℝ → ℝ → ℝ
  F_nonneg : ∀ k l : ℝ, 0 ≤ k → 0 ≤ l → 0 ≤ F k l

namespace RamseySolowModel

/-- The production set Y = {(-k, -l, x, 0) : k ≥ 0, l ≥ 0, x ≤ F(k,l)} − ℝ⁴₊. -/
def productionSet (m : RamseySolowModel) : Set (ℝ × ℝ × ℝ × ℝ) :=
  {y | ∃ k l x : ℝ, 0 ≤ k ∧ 0 ≤ l ∧ x ≤ m.F k l ∧
    y.1 ≤ -k ∧ y.2.1 ≤ -l ∧ y.2.2.1 ≤ x ∧ y.2.2.2 ≤ 0}

end RamseySolowModel