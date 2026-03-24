import Mathlib
open Topology

structure HiddenInfoTwoType where
  e_star_L : ℝ
  he_star_L_pos : 0 < e_star_L

theorem Lemma_14C4 (M : HiddenInfoTwoType)
    (profit : ℝ → ℝ)
    (e_L : ℝ)
    (h_ic : e_L ≤ M.e_star_L)
    (h_optimal : ∀ e' : ℝ, profit e' ≤ profit e_L)
    (h_profitable_deviation : e_L = M.e_star_L →
      ∃ e' : ℝ, e' < M.e_star_L ∧ profit e' > profit M.e_star_L) :
    e_L < M.e_star_L := by
  by_contra h
  push_neg at h
  have heq : e_L = M.e_star_L := le_antisymm h_ic h
  obtain ⟨e', _, he'_better⟩ := h_profitable_deviation heq
  have h_le := h_optimal e'
  rw [heq] at h_le
  linarith