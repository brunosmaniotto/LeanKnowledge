import Mathlib
open Topology

/-- Returns to scale: how output responds when all inputs are varied in the same
    proportion. Given a production function `f` and an input vector `z`,
    `returnsToScale f z α` is the output `f(α • z)` — the response along the
    ray through `z` in input space as the scale of operation changes by factor `α`. -/
def returnsToScale {n : ℕ} (f : (Fin n → ℝ) → ℝ) (z : Fin n → ℝ) : ℝ → ℝ :=
  fun α => f (α • z)