import Mathlib
open Topology

/-- A real-valued function on ℝⁿ: a function mapping vectors in ℝⁿ into points in ℝ.
    The domain is `Fin n → ℝ` (Mathlib's representation of ℝⁿ) and the
    codomain is ℝ, so the range is automatically contained in ℝ. -/
abbrev RealValuedFunction (n : ℕ) := (Fin n → ℝ) → ℝ