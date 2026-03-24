import Mathlib

open Set
open Topology

/-- Under strict concavity, if two points both achieve the maximum on a convex set,
    then they must be equal — i.e., the optimizer is unique. -/
theorem claim_A2_13_a {s : Set ℝ} {f : ℝ → ℝ} (hs : Convex ℝ s)
    (hf : StrictConcaveOn ℝ s f)
    (x y : ℝ) (hx : x ∈ s) (hy : y ∈ s)
    (hmax_x : ∀ z ∈ s, f z ≤ f x)
    (hmax_y : ∀ z ∈ s, f z ≤ f y) :
    x = y := by
  by_contra hne
  have hmid : (1/2 : ℝ) * x + (1/2 : ℝ) * y ∈ s := by
    apply hs hx hy (by positivity) (by positivity)
    norm_num
  have hsc := hf.2 hx hy hne (by positivity : (0:ℝ) < 1/2) (by positivity : (0:ℝ) < 1/2)
    (by norm_num : (1:ℝ)/2 + 1/2 = 1)
  have heq : f x = f y := le_antisymm (hmax_y x hx) (hmax_x y hy)
  have hle : f ((1/2 : ℝ) * x + (1/2 : ℝ) * y) ≤ f x := hmax_x _ hmid
  simp only [smul_eq_mul] at hsc
  linarith