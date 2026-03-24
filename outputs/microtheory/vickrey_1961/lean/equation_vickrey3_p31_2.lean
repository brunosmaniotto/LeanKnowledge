import Mathlib

open Real
open Topology

/-- First-order condition for bidder 2's optimal bidding strategy in Vickrey (1961).
    If y₁ is differentiable and the expected gain E(g₂) is maximized at bid x,
    then -y₁(x) + (v₂ - x) * y₁'(x) = 0. -/
theorem equation_Vickrey3_p31_2
    (y₁ : ℝ → ℝ) (v₂ x : ℝ)
    (hy₁ : Differentiable ℝ y₁)
    -- E(g₂)(x) = (v₂ - x) * y₁(x), and x is a critical point
    (hcrit : HasDerivAt (fun t => (v₂ - t) * y₁ t) 0 x) :
    -y₁ x + (v₂ - x) * deriv y₁ x = 0 := by
  have hd : HasDerivAt (fun t => v₂ - t) (-1) x := by
    have := (hasDerivAt_const x v₂).sub (hasDerivAt_id x)
    simp at this
    exact this
  have hy₁x : HasDerivAt y₁ (deriv y₁ x) x :=
    (hy₁ x).hasDerivAt
  have hprod : HasDerivAt (fun t => (v₂ - t) * y₁ t)
    ((-1) * y₁ x + (v₂ - x) * deriv y₁ x) x :=
    hd.mul hy₁x
  have huniq := hcrit.unique hprod
  linarith