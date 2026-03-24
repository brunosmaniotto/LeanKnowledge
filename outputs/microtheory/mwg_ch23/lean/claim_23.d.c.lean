import Mathlib

open Finset BigOperators
open BigOperators

theorem expected_externality_budget_balance
    {I : ℕ} (hI : 1 < I)
    (ε : Fin I → ℝ)
    (t : Fin I → ℝ)
    (ht : ∀ i, t i = ε i - (1 / ((I : ℝ) - 1)) * ∑ j ∈ univ.erase i, ε j) :
    ∑ i, t i = 0 := by
  simp_rw [ht]
  have hI1 : (I : ℝ) - 1 ≠ 0 := by
    have : (1 : ℝ) < (I : ℝ) := Nat.one_lt_cast.mpr hI
    linarith
  have hkey : ∑ i : Fin I, ∑ j ∈ univ.erase i, ε j =
      ((I : ℝ) - 1) * ∑ j, ε j := by
    have hsub : ∀ i : Fin I, ∑ j ∈ univ.erase i, ε j = ∑ j, ε j - ε i :=
      fun i => sum_erase_eq_sub (mem_univ i)
    simp_rw [hsub, Finset.sum_sub_distrib, sum_const, card_fin]
    rw [nsmul_eq_mul]
    ring
  simp_rw [Finset.sum_sub_distrib]
  rw [← Finset.mul_sum]
  rw [hkey]
  field_simp
  ring