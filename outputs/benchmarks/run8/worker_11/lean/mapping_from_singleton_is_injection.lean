import Mathlib

theorem injection_from_subsingleton {S T : Type} [Subsingleton S] (f : S → T) :
    Function.Injective f := by
  intro x y _
  exact Subsingleton.elim x y