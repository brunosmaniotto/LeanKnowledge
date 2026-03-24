import Mathlib

open MeasureTheory Set

theorem hicksian_demand_welfare_integrals
    (e : ℝ → ℝ → ℝ)
    (h1 : ℝ → ℝ → ℝ)
    (p0 p1 w u0 u1 : ℝ)
    (hderiv0 : ∀ p, HasDerivAt (e · u0) (h1 p u0) p)
    (hderiv1 : ∀ p, HasDerivAt (e · u1) (h1 p u1) p)
    (hcont0 : Continuous (h1 · u0))
    (hcont1 : Continuous (h1 · u1))
    (he0 : e p0 u0 = w)
    (he1 : e p1 u1 = w) :
    (∫ p in p1..p0, h1 p u1 = e p0 u1 - w) ∧
    (∫ p in p1..p0, h1 p u0 = w - e p1 u0) := by
  constructor
  · have := intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun p _ => hderiv1 p) (hcont1.intervalIntegrable p1 p0)
    linarith [he1]
  · have := intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun p _ => hderiv0 p) (hcont0.intervalIntegrable p1 p0)
    linarith [he0]