import Mathlib

open Matrix
open Topology

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A matrix M is positive semidefinite iff -M is negative semidefinite. -/
theorem psd_iff_neg_nsd (M : Matrix n n ℝ) :
    (M.IsHermitian ∧ ∀ x : n → ℝ, 0 ≤ x ⬝ᵥ M *ᵥ x) ↔
    ((-M).IsHermitian ∧ ∀ x : n → ℝ, x ⬝ᵥ (-M) *ᵥ x ≤ 0) := by
  constructor
  · rintro ⟨hH, hpos⟩
    refine ⟨hH.neg, fun x => ?_⟩
    simp only [neg_mulVec, dotProduct_neg]
    linarith [hpos x]
  · rintro ⟨hH, hneg⟩
    have hH' : M.IsHermitian := by
      have := hH.neg
      simp at this
      exact this
    refine ⟨hH', fun x => ?_⟩
    have h := hneg x
    simp only [neg_mulVec, dotProduct_neg] at h
    linarith