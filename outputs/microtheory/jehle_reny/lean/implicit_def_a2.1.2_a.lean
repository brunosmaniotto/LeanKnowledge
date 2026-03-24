import Mathlib
open Topology

/-- The directional derivative of `f` at `x` in direction `z`,
    defined as g'(0) where g(t) = f(x + t • z). -/
noncomputable def directionalDeriv {n : ℕ}
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (x z : EuclideanSpace ℝ (Fin n)) : ℝ :=
  deriv (fun t : ℝ => f (x + t • z)) 0