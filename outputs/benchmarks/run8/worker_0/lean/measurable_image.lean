import Mathlib
open Set
open MeasureTheory
open EReal
open Classical

variable [MeasurableSpace ℝ] (f : ℝ → EReal)

lemma condition1_iff_condition4 (f : ℝ → EReal) :
    (∀ α : ℝ, MeasurableSet {x | f x > (α : EReal)}) ↔ (∀ α : ℝ, MeasurableSet {x | f x ≤ (α : EReal)}) := by
  constructor
  · intro h α
    have : {x | f x ≤ (α : EReal)} = {x | f x > (α : EReal)}ᶜ := by
      ext x
      simp [not_lt]
    rw [this]
    exact (h α).compl
  · intro h α
    have : {x | f x > (α : EReal)} = {x | f x ≤ (α : EReal)}ᶜ := by
      ext x
      simp [not_le]
    rw [this]
    exact (h α).compl