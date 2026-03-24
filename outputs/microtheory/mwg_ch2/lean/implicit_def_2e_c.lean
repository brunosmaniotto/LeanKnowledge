import Mathlib
open Topology

/-- The wealth effect (income effect) for the `l`-th good, given a demand function `x`.
    This is the partial derivative ∂x_l(p, w)/∂w, measuring how demand for good `l`
    responds to a marginal change in wealth `w`, holding prices `p` fixed. -/
noncomputable def wealthEffect (n : ℕ) (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))
    (p : Fin n → ℝ) (w : ℝ) (l : Fin n) : ℝ :=
  deriv (fun w' => x p w' l) w