import Mathlib
open Topology

/-- When effort is unobservable, incentive compatibility (making high effort preferable)
    requires w_high > w_low, which conflicts with full insurance (w_high = w_low).
    This proves that any IC-compatible contract cannot fully insure the manager. -/
theorem effort_insurance_conflict
    (w_high w_low : ℝ)
    (p_H p_L : ℝ)
    (cost_high cost_low : ℝ)
    (hp : p_H > p_L)
    (hc : cost_high > cost_low)
    (ic : p_H * w_high + (1 - p_H) * w_low - cost_high ≥
          p_L * w_high + (1 - p_L) * w_low - cost_low) :
    w_high ≠ w_low := by
  intro h
  rw [h] at ic
  nlinarith