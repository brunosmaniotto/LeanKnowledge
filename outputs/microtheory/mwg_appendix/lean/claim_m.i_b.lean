import Mathlib
open Topology

theorem Claim_M_I_b : ¬Convex ℝ {x : ℝ | ‖x‖ = 1} := by
  intro h
  have h1 : (1 : ℝ) ∈ {x : ℝ | ‖x‖ = 1} := by
    simp [Set.mem_setOf_eq]
  have h2 : (-1 : ℝ) ∈ {x : ℝ | ‖x‖ = 1} := by
    simp [Set.mem_setOf_eq]
  have hmid := h h1 h2 (by norm_num : (0 : ℝ) ≤ 1 / 2) (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (1 : ℝ) / 2 + 1 / 2 = 1)
  simp only [Set.mem_setOf_eq] at hmid
  norm_num [smul_eq_mul] at hmid