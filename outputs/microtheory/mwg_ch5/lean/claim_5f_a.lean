import Mathlib

open Set
open Topology

/-- Claim 5F(a): Efficient production plans lie on the boundary of Y.
    The converse fails: some boundary points of Y are not efficient. -/
theorem Claim_5F_a :
    -- Part 1: Interior ⟹ not efficient (contrapositive: efficient ⟹ boundary)
    (∀ (Y : Set (ℝ × ℝ)) (y : ℝ × ℝ),
      (∃ ε > (0 : ℝ), ∀ y' : ℝ × ℝ, |y'.1 - y.1| < ε → |y'.2 - y.2| < ε → y' ∈ Y) →
      ∃ y' ∈ Y, y.1 ≤ y'.1 ∧ y.2 ≤ y'.2 ∧ y ≠ y') ∧
    -- Part 2: ∃ boundary point that is not efficient
    (∃ (Y : Set (ℝ × ℝ)) (y : ℝ × ℝ),
      y ∈ Y ∧
      ¬(∃ ε > (0 : ℝ), ∀ y' : ℝ × ℝ, |y'.1 - y.1| < ε → |y'.2 - y.2| < ε → y' ∈ Y) ∧
      ∃ y' ∈ Y, y.1 ≤ y'.1 ∧ y.2 ≤ y'.2 ∧ y ≠ y') := by
  constructor
  · -- Part 1: shift interior point by +ε/2 in each coordinate
    intro Y y hint
    obtain ⟨ε, hε, hball⟩ := hint
    have hε2 := half_pos hε
    refine ⟨(y.1 + ε / 2, y.2 + ε / 2), hball _ ?_ ?_, by linarith, by linarith, ?_⟩
    · -- |(y.1 + ε/2) - y.1| < ε
      show |y.1 + ε / 2 - y.1| < ε
      rw [(show y.1 + ε / 2 - y.1 = ε / 2 by ring), abs_of_pos hε2]
      linarith
    · -- |(y.2 + ε/2) - y.2| < ε
      show |y.2 + ε / 2 - y.2| < ε
      rw [(show y.2 + ε / 2 - y.2 = ε / 2 by ring), abs_of_pos hε2]
      linarith
    · -- y ≠ (y.1 + ε/2, y.2 + ε/2)
      intro h
      have h1 := congr_arg Prod.fst h
      simp only [Prod.fst] at h1
      linarith
  · -- Part 2: Y = {p | p.1 ≤ 0}, y = (0,-1) is boundary but dominated by (0,0)
    refine ⟨{p : ℝ × ℝ | p.1 ≤ 0}, (0, -1), by norm_num, ?_, (0, 0), by norm_num,
      by norm_num, by norm_num, ?_⟩
    · -- (0,-1) is not in the interior of Y
      rintro ⟨ε, hε, hball⟩
      have h := hball (ε / 2, -1)
        (by show |ε / 2 - 0| < ε; rw [sub_zero, abs_of_pos (half_pos hε)]; linarith)
        (by show |(-1 : ℝ) - (-1)| < ε; rw [sub_self, abs_zero]; linarith)
      simp only [mem_setOf_eq, Prod.fst] at h
      linarith
    · -- (0,-1) ≠ (0,0)
      intro h
      have := congr_arg Prod.snd h
      simp only [Prod.snd] at this
      norm_num at this