import Mathlib

open BigOperators Finset
open Topology

/-- The short-run (restricted) cost function. Given production function `f`,
    variable input prices `w`, fixed input prices `wBar`, fixed input levels `xBar`,
    and output target `y`, the short-run cost is the infimum of `w · x + wBar · xBar`
    over all variable input vectors `x` satisfying `f(x, xBar) ≥ y`. -/
noncomputable def shortRunCost
    {n m : ℕ}
    (f : (Fin n → ℝ) → (Fin m → ℝ) → ℝ)
    (w : Fin n → ℝ)
    (wBar : Fin m → ℝ)
    (xBar : Fin m → ℝ)
    (y : ℝ) : ℝ :=
  sInf { c : ℝ | ∃ x : Fin n → ℝ, f x xBar ≥ y ∧
    c = ∑ i : Fin n, w i * x i + ∑ j : Fin m, wBar j * xBar j }