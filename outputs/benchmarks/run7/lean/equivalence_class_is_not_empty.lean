import Mathlib

theorem equivalence_class_nonempty {S : Type} (R : S → S → Prop) (h : Equivalence R) (x : S) :
    Set.Nonempty {y : S | R y x} := by
  refine ⟨x, ?_⟩
  exact h.refl x