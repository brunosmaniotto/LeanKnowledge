import Mathlib
open Topology

/-- When agent 2's type is θ₂'' and preferences make y preferred to x,
    agent 2 prefers the outcome from lying (y) over truth-telling (x). -/
theorem Example_23_B_1 :
    let u : Fin 3 → ℕ := ![2, 1, 0]  -- utility for [y, x, z] under θ₂''
    let outcome_truthful := 1  -- index of x (truth: f(θ₁,θ₂'') = x)
    let outcome_lie := 0       -- index of y (lie: f(θ₁,θ₂') = y)
    u outcome_lie > u outcome_truthful := by
  native_decide