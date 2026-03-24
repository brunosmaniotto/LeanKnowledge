import Mathlib
open Topology

variable {n : ℕ}

/-- The y-level isoquant of a production function f: the set of non-negative
    input vectors that produce exactly y units of output.
    Q(y) = {x ≥ 0 | f(x) = y} (Jehle & Reny, Definition 3.2). -/
def isoquant (f : (Fin n → ℝ) → ℝ) (y : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ f x = y}

/-- The isoquant through input vector x: Q(f(x)). -/
abbrev isoquantThrough (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) : Set (Fin n → ℝ) :=
  isoquant f (f x)