import Mathlib

theorem antireflexive_transitive_is_asymmetric {S : Type*} (R : S → S → Prop)
    (antirefl : ∀ x, ¬ R x x) (trans : ∀ x y z, R x y → R y z → R x z) :
    ∀ x y, R x y → ¬ R y x := by
  intro x y hxy hyx
  have hxx : R x x := trans x y x hxy hyx
  exact antirefl x hxx