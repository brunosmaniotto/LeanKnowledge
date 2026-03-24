import Mathlib
open Topology

variable (ConsumerIndex : Type) (L : ℕ)

-- We introduce `phi_fn` as an uninterpreted function that exists in our context.
-- The problem statement describes properties of `φ_i` (twice differentiable with `φ_i'' < 0`),
-- but these are properties of the function, not part of its primary definition.
-- The specific implementation of `phi_fn` is not provided in the problem description,
-- so we treat it as an external given function.
variable (phi_fn : ConsumerIndex → (Fin L → ℝ) → ℝ → ℝ)

/--
`derivedUtility i p w_i h` is the derived utility function for consumer `i` in a quasilinear model.
It is defined as `φ_i(p, h) + w_i`.
- `i`: Consumer index
- `p`: Price vector for `L` traded goods (represented as a function from `Fin L` to `ℝ`)
- `w_i`: Wealth of consumer `i`
- `h`: Externality level
-/
def derivedUtility (i : ConsumerIndex) (p : Fin L → ℝ) (w_i : ℝ) (h : ℝ) : ℝ :=
  phi_fn i p h + w_i