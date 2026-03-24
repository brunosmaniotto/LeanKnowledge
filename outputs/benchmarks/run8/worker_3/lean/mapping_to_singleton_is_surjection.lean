import Mathlib

theorem surjective_of_nonempty_domain_singleton_codomain {S T : Type*} (hS : Nonempty S) (hT : Unique T) (f : S → T) :
    Function.Surjective f := by
  intro y
  rcases hS with ⟨x⟩
  use x
  exact Subsingleton.elim (f x) y