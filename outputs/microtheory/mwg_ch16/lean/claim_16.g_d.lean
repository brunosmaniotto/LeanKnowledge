import Mathlib
open Topology

/-- The converse of Proposition 16.G.1 is not true: not every marginal cost price
equilibrium is Pareto optimal. With nonconvex production sets, marginal cost pricing
satisfies only first-order conditions and may fail second-order conditions for social
utility maximization. -/
theorem Claim_16_G_d :
    ∃ (u : ℝ → ℝ) (Y : Set ℝ) (x_star x' : ℝ),
      ¬Convex ℝ Y ∧
      x_star ∈ Y ∧
      x' ∈ Y ∧
      u x' > u x_star := by
  refine ⟨fun x => x, {0, 1, 3}, 1, 3, ?_, ?_, ?_, ?_⟩
  · -- Y = {0, 1, 3} is not convex: 0 ∈ Y, 3 ∈ Y, but (1/2)*0 + (1/2)*3 = 1.5 ∉ Y
    intro h
    have h15 := h (Set.mem_insert 0 {1, 3})
      (Set.mem_insert_of_mem 0 (Set.mem_insert_of_mem 1 (Set.mem_singleton 3)))
      (show (0:ℝ) ≤ 1/2 by norm_num) (show (0:ℝ) ≤ 1/2 by norm_num)
      (by ring)
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at h15
    norm_num at h15
  · exact Set.mem_insert_of_mem 0 (Set.mem_insert 1 {3})
  · exact Set.mem_insert_of_mem 0 (Set.mem_insert_of_mem 1 (Set.mem_singleton 3))
  · norm_num