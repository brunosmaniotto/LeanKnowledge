import Mathlib
open Topology

/-- The equilibrium condition for bidder 2 in the simplified Vickrey game:
    -y₁(x) + (a - x)·y₁'(x) = 0, equivalently y₁(x) = (a - x)·y₁'(x). -/
theorem equation_vickrey3_p33_18 (y₁ : ℝ → ℝ) (a x : ℝ) :
    -y₁ x + (a - x) * deriv y₁ x = 0 ↔ y₁ x = (a - x) * deriv y₁ x := by
  constructor <;> intro h <;> linarith