import Mathlib

theorem injection_iff_left_inverse (S T : Type*) [Nonempty S] (f : S → T) :
    Function.Injective f ↔ ∃ g : T → S, g ∘ f = id := by
  rw [Function.injective_iff_hasLeftInverse]
  constructor
  · rintro ⟨g, hg⟩
    exact ⟨g, by ext x; exact hg x⟩
  · rintro ⟨g, hg⟩
    refine ⟨g, fun x => ?_⟩
    calc
      g (f x) = (g ∘ f) x := rfl
      _ = id x := by rw [hg]
      _ = x := rfl