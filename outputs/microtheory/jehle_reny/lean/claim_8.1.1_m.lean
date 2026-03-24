import Mathlib
open Topology

/-- Under uniform F on [0,1], g(p) = (1 + h(p))·L/2 inherits strict monotonicity
    and strict convexity from h. -/
theorem Claim_8_1_1_m
    (h : ℝ → ℝ) (L : ℝ) (s : Set ℝ)
    (hL : 0 < L)
    (h_mono : StrictMono h)
    (h_convex : StrictConvexOn ℝ s h) :
    StrictMono (fun p => (1 + h p) * L / 2) ∧
    StrictConvexOn ℝ s (fun p => (1 + h p) * L / 2) := by
  have hL2 : (0 : ℝ) < L / 2 := by linarith
  refine ⟨fun a b hab => by nlinarith [h_mono hab],
         h_convex.1, fun x hx y hy hxy a b ha hb hab => ?_⟩
  have h_sc := h_convex.2 hx hy hxy ha hb hab
  simp only [smul_eq_mul] at *
  nlinarith