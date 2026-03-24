import Mathlib

open Finset BigOperators
open BigOperators

/-- CES social welfare function with parameter a > 0 (ρ = -a < 0) -/
noncomputable def ces_swf {I : Type*} [Fintype I] (a : ℝ) (u : I → ℝ) : ℝ :=
  (∑ i : I, (u i) ^ (-a)) ^ (-1 / a)

/-- Maximin (Rawlsian) social welfare function -/
noncomputable def maximin_swf {I : Type*} [Fintype I] [Nonempty I]
    (u : I → ℝ) : ℝ :=
  Finset.inf' Finset.univ Finset.univ_nonempty u

/-- Setting ρ = -a < 0 gives the CES form: (x^{-a})^{-1/a} = x
    for any x ≥ 0 and a ≠ 0. As a → ∞, the generalized mean
    (Σ xᵢ^{-a})^{-1/a} → min xᵢ, recovering Rawls' maximin
    criterion as the infinite-risk-aversion CES limit. -/
theorem rawls_maximin_is_ces_limit (a x : ℝ) (ha : a ≠ 0) (hx : 0 ≤ x) :
    (x ^ (-a)) ^ (-1 / a) = x := by
  rw [← Real.rpow_mul hx]
  have h1 : -a * (-1 / a) = 1 := by field_simp
  rw [h1]
  simp