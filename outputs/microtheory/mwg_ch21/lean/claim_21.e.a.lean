import Mathlib

theorem social_welfare_functional_induces_choice
    {X : Type*} [Fintype X] [Nonempty X] {A : Type*}
    (F : A → LinearOrder X) :
    ∃ c : A → X, ∀ a : A,
      ∀ x : X, @LE.le X (@Preorder.toLE X (@PartialOrder.toPreorder X (@LinearOrder.toPartialOrder X (F a)))) x (c a) := by
  refine ⟨fun a => by letI := F a; exact Finset.max' Finset.univ Finset.univ_nonempty, fun a x => ?_⟩
  show @LE.le X (@Preorder.toLE X (@PartialOrder.toPreorder X (@LinearOrder.toPartialOrder X (F a)))) x _
  letI := F a
  exact Finset.le_max' Finset.univ x (Finset.mem_univ x)