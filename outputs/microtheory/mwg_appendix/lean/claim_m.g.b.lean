import Mathlib

open Set
open Topology

/-- The intersection of any number of convex sets is convex,
    but the union of convex sets need not be convex. -/
theorem claim_M_G_b :
    (∀ {E : Type*} [inst : AddCommMonoid E] [inst2 : Module ℝ E]
      {ι : Type*} {s : ι → Set E},
      (∀ i, Convex ℝ (s i)) → Convex ℝ (⋂ i, s i)) ∧
    (∃ (A B : Set ℝ), Convex ℝ A ∧ Convex ℝ B ∧ ¬Convex ℝ (A ∪ B)) := by
  constructor
  · intro E _ _ ι s hs
    exact convex_iInter fun i => hs i
  · refine ⟨Set.Icc 0 1, Set.Icc 2 3, convex_Icc 0 1, convex_Icc 2 3, ?_⟩
    intro h
    have h0 : (0 : ℝ) ∈ Set.Icc 0 1 ∪ Set.Icc 2 3 := by
      left; constructor <;> linarith
    have h3 : (3 : ℝ) ∈ Set.Icc 0 1 ∪ Set.Icc 2 3 := by
      right; constructor <;> linarith
    have hmid := h h0 h3 (show (0:ℝ) ≤ 1/2 by linarith) (show (0:ℝ) ≤ 1/2 by linarith)
      (by ring : (1:ℝ)/2 + 1/2 = 1)
    simp only [smul_eq_mul] at hmid
    rcases hmid with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> linarith