import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Example 9.4: VCG mechanism for the bridge-building problem.
    Efficient allocation rule and VCG cost computation. -/
theorem Example_9_4
    {N : ℕ} (hN : 0 < N)
    (t : Fin N → ℝ)
    (v_B : Fin N → ℝ) (hv_B : ∀ i, v_B i = 2 * t i)
    (v_S : Fin N → ℝ) (hv_S : ∀ i, v_S i = t i + 5) :
    -- (1) Efficient allocation: B iff Σ(t_i - 5) > 0
    ((∑ i, v_B i > ∑ i, v_S i) ↔ ∑ i : Fin N, (t i - 5) > 0) ∧
    -- (2) VCG cost when pivotal for B: Σ_{j≠i}(5 - t_j)
    (∀ i, ∑ j ∈ Finset.univ.erase i, v_S j - ∑ j ∈ Finset.univ.erase i, v_B j =
      ∑ j ∈ Finset.univ.erase i, (5 - t j)) ∧
    -- (3) VCG cost when pivotal for S: Σ_{j≠i}(t_j - 5)
    (∀ i, ∑ j ∈ Finset.univ.erase i, v_B j - ∑ j ∈ Finset.univ.erase i, v_S j =
      ∑ j ∈ Finset.univ.erase i, (t j - 5)) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Part 1: B is efficient iff Σ(t_i - 5) > 0
    constructor
    · intro h
      have hB : ∑ i, v_B i = ∑ i, (2 * t i) := Finset.sum_congr rfl (fun i _ => hv_B i)
      have hS : ∑ i, v_S i = ∑ i, (t i + 5) := Finset.sum_congr rfl (fun i _ => hv_S i)
      rw [hB, hS] at h
      have h2 : ∑ i : Fin N, (2 * t i) - ∑ i : Fin N, (t i + 5) =
                ∑ i : Fin N, (t i - 5) := by
        rw [← Finset.sum_sub_distrib]
        apply Finset.sum_congr rfl; intro i _; ring
      linarith
    · intro h
      have hB : ∑ i, v_B i = ∑ i, (2 * t i) := Finset.sum_congr rfl (fun i _ => hv_B i)
      have hS : ∑ i, v_S i = ∑ i, (t i + 5) := Finset.sum_congr rfl (fun i _ => hv_S i)
      rw [hB, hS]
      have : ∑ i : Fin N, (2 * t i) - ∑ i : Fin N, (t i + 5) =
             ∑ i : Fin N, (t i - 5) := by
        rw [← Finset.sum_sub_distrib]
        apply Finset.sum_congr rfl; intro i _; ring
      linarith
  · -- Part 2: VCG cost when pivotal for B
    intro i
    calc ∑ j ∈ Finset.univ.erase i, v_S j - ∑ j ∈ Finset.univ.erase i, v_B j
        = ∑ j ∈ Finset.univ.erase i, (v_S j - v_B j) := by
          rw [← Finset.sum_sub_distrib]
      _ = ∑ j ∈ Finset.univ.erase i, ((t j + 5) - 2 * t j) := by
          apply Finset.sum_congr rfl; intro j _; rw [hv_S, hv_B]
      _ = ∑ j ∈ Finset.univ.erase i, (5 - t j) := by
          apply Finset.sum_congr rfl; intro j _; ring
  · -- Part 3: VCG cost when pivotal for S
    intro i
    calc ∑ j ∈ Finset.univ.erase i, v_B j - ∑ j ∈ Finset.univ.erase i, v_S j
        = ∑ j ∈ Finset.univ.erase i, (v_B j - v_S j) := by
          rw [← Finset.sum_sub_distrib]
      _ = ∑ j ∈ Finset.univ.erase i, (2 * t j - (t j + 5)) := by
          apply Finset.sum_congr rfl; intro j _; rw [hv_B, hv_S]
      _ = ∑ j ∈ Finset.univ.erase i, (t j - 5) := by
          apply Finset.sum_congr rfl; intro j _; ring