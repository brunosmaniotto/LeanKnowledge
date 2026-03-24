import Mathlib
open Finset BigOperators

axiom QuadraticIrrational : ℝ → Prop
axiom contFraction : ℝ → Type
axiom Periodic : ∀ {x : ℝ}, contFraction x → Prop
axiom cf : ∀ x : ℝ, contFraction x

theorem irrational_has_periodic_contfrac_iff_quadratic (x : ℝ) (hx : Irrational x) :
    QuadraticIrrational x ↔ Periodic (cf x) := by
  sorry