import Mathlib

open Real
open Topology

theorem Example_1_4
    (p₁ p₂ r u y : ℝ)
    (hr : r ≠ 0)
    (hS : 0 < p₁ ^ r + p₂ ^ r) :
    let S := p₁ ^ r + p₂ ^ r
    let v := fun w => w * S ^ (-(1 / r))
    let e := fun u => u * S ^ (1 / r)
    v (e u) = u ∧ e (v y) = y := by
  dsimp only
  constructor
  · rw [mul_assoc, ← rpow_add hS]
    have h : (1 : ℝ) / r + -(1 / r) = 0 := by ring
    rw [h, rpow_zero, mul_one]
  · rw [mul_assoc, ← rpow_add hS]
    have h : -(1 / r) + 1 / r = 0 := by ring
    rw [h, rpow_zero, mul_one]