import Mathlib
open Topology

/-- Any critical point of a convex function is a global minimizer. -/
theorem critical_point_global_minimizer_convex
    {f : ℝ → ℝ} {s : Set ℝ} {x : ℝ}
    (hs : Convex ℝ s) (hx : x ∈ s)
    (hf : ConvexOn ℝ s f)
    (hdf : DifferentiableOn ℝ f s) (hs_open : IsOpen s)
    (hcrit : deriv f x = 0) :
    ∀ y ∈ s, f x ≤ f y := by
  intro y hy
  have hdiff : DifferentiableAt ℝ f x := (hdf x hx).differentiableAt (hs_open.mem_nhds hx)
  have hder : HasDerivAt f 0 x := by rw [← hcrit]; exact hdiff.hasDerivAt
  rcases lt_trichotomy x y with hlt | heq | hgt
  · -- x < y: 0 = f'(x) ≤ slope f x y, and 0 ≤ slope ↔ f x ≤ f y
    have h := hf.le_slope_of_hasDerivAt hx hy hlt hder
    rwa [slope_nonneg_iff_of_le hlt.le] at h
  · rw [heq]
  · -- y < x: slope f y x ≤ f'(x) = 0, and slope ≤ 0 ↔ f x ≤ f y
    have h := hf.slope_le_of_hasDerivAt hy hx hgt hder
    rwa [slope_nonpos_iff_of_le hgt.le] at h