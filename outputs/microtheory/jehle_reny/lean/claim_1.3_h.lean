import Mathlib
open Topology

theorem Claim_1_3_h
    {n : ℕ} [NeZero n]
    (Du : Fin n → ℝ)
    (p : Fin n → ℝ)
    (lambda_star : ℝ)
    (hp_pos : ∀ j, p j > 0)
    (hFOC : ∀ j, Du j = lambda_star * p j)
    (i : Fin n)
    (hDu_pos : Du i > 0) :
    lambda_star > 0 ∧ ∀ j, Du j > 0 := by
  have h1 : lambda_star * p i > 0 := by linarith [hFOC i]
  have hlam : lambda_star > 0 := by
    rcases mul_pos_iff.mp h1 with ⟨ha, _⟩ | ⟨_, hb⟩
    · exact ha
    · linarith [hp_pos i]
  exact ⟨hlam, fun j => by rw [hFOC j]; exact mul_pos hlam (hp_pos j)⟩