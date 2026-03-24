import Mathlib
open Topology

theorem lexicographic_dictatorship_not_representable :
    ¬ ∃ (f : Lex (ℝ × ℝ) → ℝ), StrictMono f := by
  intro ⟨f, hf⟩
  have h_lt : ∀ x : ℝ, f (toLex (x, 0)) < f (toLex (x, 1)) := by
    intro x
    apply hf
    exact Prod.Lex.lt_iff.mpr (Or.inr ⟨rfl, zero_lt_one⟩)
  have h_rat : ∀ x : ℝ, ∃ q : ℚ, f (toLex (x, 0)) < (q : ℝ) ∧ (q : ℝ) < f (toLex (x, 1)) :=
    fun x => exists_rat_btwn (h_lt x)
  choose g hg using h_rat
  have g_inj : Function.Injective g := by
    intro a b hab
    by_contra h
    have hab' : (g a : ℝ) = (g b : ℝ) := congrArg Rat.cast hab
    rcases lt_or_gt_of_ne h with h_ab | h_ba
    · have h1 : f (toLex (a, 1)) ≤ f (toLex (b, 0)) := by
        apply le_of_lt; apply hf
        exact Prod.Lex.lt_iff.mpr (Or.inl h_ab)
      linarith [(hg a).2, (hg b).1]
    · have h1 : f (toLex (b, 1)) ≤ f (toLex (a, 0)) := by
        apply le_of_lt; apply hf
        exact Prod.Lex.lt_iff.mpr (Or.inl h_ba)
      linarith [(hg b).2, (hg a).1]
  exact (not_countable (g_inj.countable)).elim