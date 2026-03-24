import Mathlib

open Real
open Topology

/-- Short-run Cobb-Douglas with fixed x₂ exhibits decreasing returns in x₁:
    scaling the variable input by t > 1 scales output by t^α < t since α < 1,
    ensuring short-run profits are bounded. -/
theorem claim_3_6_a (α : ℝ) (hα0 : 0 < α) (hα1 : α < 1) :
    ∀ t : ℝ, 1 < t → t ^ α < t := by
  intro t ht
  have h := rpow_lt_rpow_of_exponent_lt ht hα1
  rwa [rpow_one] at h