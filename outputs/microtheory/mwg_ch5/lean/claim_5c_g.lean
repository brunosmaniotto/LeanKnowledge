import Mathlib

open scoped BigOperators
open BigOperators
open Topology

variable {ι : Type*} [Fintype ι]

noncomputable def profitFn (Y : Set (ι → ℝ)) (p : ι → ℝ) : ℝ :=
  sSup {∑ i, p i * y i | y ∈ Y}

noncomputable def supportFnNegY (Y : Set (ι → ℝ)) (p : ι → ℝ) : ℝ :=
  sInf {∑ i, p i * (-y i) | y ∈ Y}

theorem Claim_5C_g (Y : Set (ι → ℝ)) (p : ι → ℝ)
    (hbdd_above : BddAbove {∑ i, p i * y i | y ∈ Y})
    (hne : Y.Nonempty) :
    profitFn Y p = -supportFnNegY Y p := by
  unfold profitFn supportFnNegY
  have h_eq : {∑ i, p i * (-y i) | y ∈ Y} = Neg.neg '' {∑ i, p i * y i | y ∈ Y} := by
    ext x
    simp only [Set.mem_setOf_eq, Set.mem_image]
    constructor
    · rintro ⟨y, hy, rfl⟩
      exact ⟨∑ i, p i * y i, ⟨y, hy, rfl⟩, by simp [mul_neg, Finset.sum_neg_distrib]⟩
    · rintro ⟨v, ⟨y, hy, rfl⟩, rfl⟩
      exact ⟨y, hy, by simp [mul_neg, Finset.sum_neg_distrib]⟩
  rw [h_eq]
  set S := {∑ i, p i * y i | y ∈ Y} with hS_def
  have hne' : S.Nonempty := by
    obtain ⟨y, hy⟩ := hne
    exact ⟨∑ i, p i * y i, ⟨y, hy, rfl⟩⟩
  have hbdd_below : BddBelow (Neg.neg '' S) := by
    obtain ⟨M, hM⟩ := hbdd_above
    exact ⟨-M, by rintro _ ⟨s, hs, rfl⟩; exact neg_le_neg (hM hs)⟩
  have hne_img : (Neg.neg '' S).Nonempty := Set.Nonempty.image _ hne'
  apply le_antisymm
  · apply csSup_le hne'
    intro x hx
    have : -x ∈ Neg.neg '' S := ⟨x, hx, rfl⟩
    have h := csInf_le hbdd_below this
    linarith
  · suffices h : -sSup S ≤ sInf (Neg.neg '' S) by linarith
    apply le_csInf hne_img
    rintro _ ⟨s, hs, rfl⟩
    exact neg_le_neg (le_csSup hbdd_above hs)