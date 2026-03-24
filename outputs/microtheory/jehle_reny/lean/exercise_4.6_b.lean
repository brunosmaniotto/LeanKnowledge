import Mathlib
open Topology

/-- If c(q) = aq + bq² with b < 0, then c is concave on ℝ, so the second-order
    condition for profit maximization (requiring convex cost) fails. -/
theorem Exercise_4_6_b (a b : ℝ) (hb : b < 0) :
    ConcaveOn ℝ Set.univ (fun q : ℝ => a * q + b * q ^ 2) := by
  refine ⟨convex_univ, fun x _ y _ s t hs ht hst => ?_⟩
  simp only [smul_eq_mul]
  have key : a * (s * x + t * y) + b * (s * x + t * y) ^ 2 -
             (s * (a * x + b * x ^ 2) + t * (a * y + b * y ^ 2)) =
             -b * (s * t) * (x - y) ^ 2 := by
    have : t = 1 - s := by linarith
    subst this; ring
  have hb' : (0 : ℝ) ≤ -b := by linarith
  linarith [mul_nonneg (mul_nonneg hb' (mul_nonneg hs ht)) (sq_nonneg (x - y))]