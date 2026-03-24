import Mathlib

theorem completeness_implies_reflexivity
    {X : Type*} (R : X → X → Prop)
    (complete : ∀ x y : X, R x y ∨ R y x) :
    ∀ x : X, R x x := by
  intro x
  exact (complete x x).elim id id