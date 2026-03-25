import Mathlib

open Set
open Topology

theorem claim_M_G_b :
    (∀ {E : Type*} [inst : AddCommMonoid E] [inst_1 : Module ℝ E]
      {ι : Type*} (S : ι → Set E), (∀ i, Convex ℝ (S i)) → Convex ℝ (⋂ i, S i)) ∧
    (∃ (A B : Set ℝ), Convex ℝ A ∧ Convex ℝ B ∧ ¬Convex ℝ (A ∪ B)) := by
  constructor
  · intro E _ _ ι S hS
    exact convex_iInter fun i => hS i
  · refine ⟨Icc 0 0, Icc 1 1, convex_Icc 0 0, convex_Icc 1 1, ?_⟩
    intro h
    have h0 : (0 : ℝ) ∈ Icc 0 0 ∪ Icc 1 1 := mem_union_left _ ⟨le_refl _, le_refl _⟩
    have h1 : (1 : ℝ) ∈ Icc 0 0 ∪ Icc 1 1 := mem_union_right _ ⟨le_refl _, le_refl _⟩
    have hmid := h h0 h1 (by norm_num : (0 : ℝ) ≤ 1/2) (by norm_num : (0 : ℝ) ≤ 1/2)
      (by norm_num : (1 : ℝ)/2 + 1/2 = 1)
    simp only [smul_eq_mul, Icc_union_Icc_eq_Icc (by norm_num : (0:ℝ) ≤ 0) (by norm_num : (0:ℝ) ≤ 1)] at hmid
    · simp only [mem_union, mem_Icc] at hmid
      rcases hmid with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> linarith