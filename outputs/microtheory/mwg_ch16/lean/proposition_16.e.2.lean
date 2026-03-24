import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {I : Type*} [Fintype I] [DecidableEq I]

theorem Proposition_16_E_2
    (U : Set (I → ℝ))
    (w : I → ℝ)
    (hw_pos : ∀ i, 0 < w i)
    (ustar : I → ℝ)
    (hustar_mem : ustar ∈ U)
    (hustar_opt : ∀ u ∈ U, ∑ i : I, w i * u i ≤ ∑ i : I, w i * ustar i)
    : ¬∃ u ∈ U, (∀ i, ustar i ≤ u i) ∧ u ≠ ustar := by
  rintro ⟨u, hu_mem, hu_ge, hu_ne⟩
  have hne : ∃ j, ustar j < u j := by
    by_contra h
    push_neg at h
    exact hu_ne (funext fun i => le_antisymm (h i) (hu_ge i))
  obtain ⟨j, hj⟩ := hne
  have hlt : ∑ i : I, w i * ustar i < ∑ i : I, w i * u i := by
    apply Finset.sum_lt_sum
    · intro i _
      exact mul_le_mul_of_nonneg_left (hu_ge i) (le_of_lt (hw_pos i))
    · exact ⟨j, Finset.mem_univ j, mul_lt_mul_of_pos_left hj (hw_pos j)⟩
  linarith [hustar_opt u hu_mem]