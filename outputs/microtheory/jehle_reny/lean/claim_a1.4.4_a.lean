import Mathlib
open Topology

/-- A convex function may have linear segments: the identity function is convex
    but not strictly convex, demonstrating that strict convexity is needed to
    rule out linear segments. -/
theorem claim_A1_4_4_a :
    (ConvexOn ℝ Set.univ (fun x : ℝ => x)) ∧
    ¬(StrictConvexOn ℝ Set.univ (fun x : ℝ => x)) := by
  constructor
  · exact convexOn_id convex_univ
  · intro ⟨_, h⟩
    have h4 := h (Set.mem_univ (0 : ℝ)) (Set.mem_univ (1 : ℝ)) (by norm_num : (0:ℝ) ≠ 1)
      (by linarith : (0:ℝ) < 1/2) (by linarith : (0:ℝ) < 1/2) (by ring : (1:ℝ)/2 + 1/2 = 1)
    simp at h4