import Mathlib

/-- A homotopy from `z₀` to `z₁` is a function `z(x, t)` for `t ∈ [0,1]`
    with `z(·, 0) = z₀` and `z(·, 1) = z₁`. -/
structure EconHomotopy (X : Type*) (Y : Type*) (z₀ z₁ : X → Y) where
  /-- The homotopy map `(x, t) ↦ z(x, t)`. -/
  toFun : X → ℝ → Y
  /-- At `t = 0` the homotopy equals `z₀`. -/
  at_zero : ∀ x, toFun x 0 = z₀ x
  /-- At `t = 1` the homotopy equals `z₁`. -/
  at_one : ∀ x, toFun x 1 = z₁ x

/-- The linear homotopy `z(x, t) = (1 - t) • z₀(x) + t • z₁(x)`. -/
noncomputable def linearEconHomotopy {X : Type*} {Y : Type*}
    [AddCommGroup Y] [Module ℝ Y] (z₀ z₁ : X → Y) : EconHomotopy X Y z₀ z₁ where
  toFun x t := (1 - t) • z₀ x + t • z₁ x
  at_zero x := by simp
  at_one x := by simp