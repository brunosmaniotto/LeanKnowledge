import Mathlib

open Function

theorem surjective_iff_has_right_inverse (hS : Nonempty S) (f : S → T) :
    Surjective f ↔ ∃ g : T → S, f ∘ g = id := by
  constructor
  · intro h
    choose g hg using h
    exact ⟨g, funext hg⟩
  · rintro ⟨g, hg⟩ y
    exact ⟨g y, congr_fun hg y⟩