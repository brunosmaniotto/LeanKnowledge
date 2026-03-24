import Mathlib
open scoped symmDiff
open Topology

/-- Hicksian wealth compensation for a price change from p to p'.
    Given an expenditure function `e`, initial utility level `u`, and initial wealth `w`,
    ΔW_Hicks = e(p', u) − w. -/
noncomputable def hicksianWealthCompensation
    {n : ℕ}
    (e : (Fin n → ℝ) → ℝ → ℝ)
    (p' : Fin n → ℝ)
    (u : ℝ)
    (w : ℝ) : ℝ :=
  e p' u - w