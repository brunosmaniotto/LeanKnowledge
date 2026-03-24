import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Example_19E3
    {S : Type*} [Fintype S] [Nonempty S] [DecidableEq S]
    (μ : S → ℝ) (r : S → ℝ)
    (hμ_nonneg : ∀ s, 0 ≤ μ s)
    (hμ_sum : ∑ s : S, μ s = 1) :
    (∑ s : S, μ s * r s) ≥ Finset.min' (Finset.univ.image r) (Finset.Nonempty.image Finset.univ_nonempty r) ∧
    (∑ s : S, μ s * r s) ≤ Finset.max' (Finset.univ.image r) (Finset.Nonempty.image Finset.univ_nonempty r) := by
  set m := Finset.min' (Finset.univ.image r) (Finset.Nonempty.image Finset.univ_nonempty r)
  set M := Finset.max' (Finset.univ.image r) (Finset.Nonempty.image Finset.univ_nonempty r)
  have hmin : ∀ s, m ≤ r s :=
    fun s => Finset.min'_le _ _ (Finset.mem_image_of_mem r (Finset.mem_univ s))
  have hmax : ∀ s, r s ≤ M :=
    fun s => Finset.le_max' _ _ (Finset.mem_image_of_mem r (Finset.mem_univ s))
  constructor
  · calc m = m * 1 := by ring
      _ = m * ∑ s : S, μ s := by rw [hμ_sum]
      _ = ∑ s : S, m * μ s := by rw [Finset.mul_sum]
      _ ≤ ∑ s : S, μ s * r s := by
            apply Finset.sum_le_sum; intro s _
            rw [mul_comm m (μ s)]
            exact mul_le_mul_of_nonneg_left (hmin s) (hμ_nonneg s)
  · calc ∑ s : S, μ s * r s
        ≤ ∑ s : S, μ s * M := by
            apply Finset.sum_le_sum; intro s _
            exact mul_le_mul_of_nonneg_left (hmax s) (hμ_nonneg s)
      _ = M * ∑ s : S, μ s := by rw [Finset.mul_sum]; congr 1; ext s; ring
      _ = M * 1 := by rw [hμ_sum]
      _ = M := by ring