import Mathlib
open Topology

variable {n : ℕ}

/-- A function f: ℝⁿ → ℝ is strictly increasing if x ≥ y and x ≠ y implies f(x) > f(y). -/
def StrictlyIncreasingOn (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, y i ≤ x i) → x ≠ y → f x > f y