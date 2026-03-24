import Mathlib

open Topology

/-- A good `i` is **inferior** at prices `p` and income `y` if its demand decreases
    as income increases, i.e., ∂x_i(p, y)/∂y < 0.
    Here `x` is a demand function mapping a price vector `p` and scalar income `y`
    to a consumption vector. -/
noncomputable def IsInferiorGood
    {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (i : Fin L)
    (p : Fin L → ℝ)
    (y : ℝ) : Prop :=
  deriv (fun w => x p w i) y < 0