import Mathlib
open Topology

theorem Lemma_8_2
    (profitA profitB : ℝ)
    (hA_nn : 0 ≤ profitA)
    (hB_nn : 0 ≤ profitB)
    (h_no_devA : ∀ t : ℝ, t < profitA + profitB → t ≤ profitA)
    (h_no_devB : ∀ t : ℝ, t < profitA + profitB → t ≤ profitB)
    : profitA = 0 ∧ profitB = 0 := by
  have hB_le : profitB ≤ 0 := by
    by_contra h
    push_neg at h
    have := h_no_devA (profitA + profitB / 2) (by linarith)
    linarith
  have hA_le : profitA ≤ 0 := by
    by_contra h
    push_neg at h
    have := h_no_devB (profitB + profitA / 2) (by linarith)
    linarith
  exact ⟨le_antisymm hA_le hA_nn, le_antisymm hB_le hB_nn⟩