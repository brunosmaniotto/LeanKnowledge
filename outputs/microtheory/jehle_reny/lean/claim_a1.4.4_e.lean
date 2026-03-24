import Mathlib

open Set
open Topology

theorem claim_A1_4_4_e {f : ℝ → ℝ}
    (hf : QuasiconvexOn ℝ Set.univ f) (y : ℝ) :
    Convex ℝ {x : ℝ | f x ≤ y} := by
  have h := hf y
  simp only [mem_univ, true_and] at h
  exact h