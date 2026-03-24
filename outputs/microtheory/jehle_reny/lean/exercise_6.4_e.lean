import Mathlib
open Topology Set Filter

variable {N : ℕ} [Fact (0 < N)]

-- Ensure Fin N → ℝ has a PartialOrder instance (component-wise)
instance : PartialOrder (Fin N → ℝ) := Pi.partialOrder

-- Define "StrictlyIncreasing" for functions from (Fin N → ℝ) to ℝ
-- This captures the property: if x ≤ y (component-wise) and x ≠ y, then W(x) < W(y).
def Function.IsStrictlyIncreasingOnRn {N : ℕ} (W : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ x y : (Fin N → ℝ), (x ≤ y) → (x ≠ y) → (W x < W y)