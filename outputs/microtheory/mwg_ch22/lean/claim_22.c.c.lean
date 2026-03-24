import Mathlib

open scoped BigOperators
open Topology

-- Part 1: Concave case
theorem social_welfare_concave_midpoint {E : Type*} [AddCommMonoid E] [Module ℝ E]
    {s : Set E} (hs : Convex ℝ s)
    {W : E → ℝ} (hW : ConcaveOn ℝ s W)
    {u u' : E} (hu : u ∈ s) (hu' : u' ∈ s)
    (heq : W u = W u') :
    W ((1/2 : ℝ) • u + (1/2 : ℝ) • u') ≥ W u := by
  have h := hW.2 hu hu' (by norm_num : (0:ℝ) ≤ 1/2) (by norm_num : (0:ℝ) ≤ 1/2)
    (by norm_num : (1/2 : ℝ) + 1/2 = 1)
  simp [heq] at h
  linarith

-- Part 2: Strictly concave case