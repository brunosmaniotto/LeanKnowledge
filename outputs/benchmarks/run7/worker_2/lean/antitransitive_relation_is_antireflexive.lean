import Mathlib

theorem antitransitive_imp_antireflexive {S : Type} {R : S → S → Prop} (h_antitrans : ∀ x y z, R x y → R y z → ¬ R x z) : ∀ x, ¬ R x x := by
  intro x h
  exact (h_antitrans x x x h h) h