import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem index_theorem_implies_odd_equilibria
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (index : ι → ℤ)
    (h_values : ∀ i, index i = 1 ∨ index i = -1)
    (h_sum : ∑ i : ι, index i = 1) :
    Odd (Fintype.card ι) := by
  set P := univ.filter (fun i => index i = 1)
  set N := univ.filter (fun i => index i = -1)
  have hPN : univ = P ∪ N := by
    ext x; constructor
    · intro _
      rcases h_values x with h | h
      · exact mem_union.mpr (Or.inl (mem_filter.mpr ⟨mem_univ x, h⟩))
      · exact mem_union.mpr (Or.inr (mem_filter.mpr ⟨mem_univ x, h⟩))
    · intro _; exact mem_univ x
  have hDisj : Disjoint P N := by
    apply Finset.disjoint_left.mpr
    intro x hxP hxN
    have h1 : index x = 1 := (mem_filter.mp hxP).2
    have h2 : index x = -1 := (mem_filter.mp hxN).2
    linarith
  have hcard : Fintype.card ι = P.card + N.card := by
    rw [← Finset.card_univ, hPN]; exact card_union_of_disjoint hDisj
  have hP_sum : ∑ i ∈ P, index i = (P.card : ℤ) := by
    rw [show ∑ i ∈ P, index i = ∑ i ∈ P, (1 : ℤ) from
      sum_congr rfl (fun x hx => (mem_filter.mp hx).2)]
    simp [sum_const, smul_eq_mul]
  have hN_sum : ∑ i ∈ N, index i = -(N.card : ℤ) := by
    rw [show ∑ i ∈ N, index i = ∑ i ∈ N, (-1 : ℤ) from
      sum_congr rfl (fun x hx => (mem_filter.mp hx).2)]
    simp [sum_const, smul_eq_mul]
  have hsplit : ∑ i : ι, index i = ∑ i ∈ P, index i + ∑ i ∈ N, index i := by
    rw [show ∑ i : ι, index i = ∑ i ∈ univ, index i from rfl, hPN, sum_union hDisj]
  rw [hsplit, hP_sum, hN_sum] at h_sum
  have hrel : (P.card : ℤ) = (N.card : ℤ) + 1 := by linarith
  have hrel_nat : P.card = N.card + 1 := by exact_mod_cast hrel
  rw [hcard, hrel_nat]
  exact ⟨N.card, by ring⟩