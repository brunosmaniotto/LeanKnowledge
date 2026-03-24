import Mathlib

/-- Good `i` is **normal** at price vector `p` and income `y` when demand for it
    is strictly increasing in income, holding prices fixed: ∂x_i(p, y)/∂y > 0. -/
def IsNormalGood {L : ℕ} (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (i : Fin L) (p : Fin L → ℝ) (y : ℝ) : Prop :=
  0 < deriv (fun w => x p w i) y