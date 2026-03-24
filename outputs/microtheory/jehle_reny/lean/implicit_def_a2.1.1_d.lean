import Mathlib
open Topology

/-- A function is Cⁿ (n-times continuously differentiable) if it possesses
    continuous derivatives f', f'', ..., f⁽ⁿ⁾. Wraps Mathlib's `ContDiff`. -/
abbrev MWG.IsConcaveOn (n : ℕ∞) (f : ℝ → ℝ) : Prop :=
  ContDiff ℝ n f