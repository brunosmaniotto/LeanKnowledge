import Mathlib

theorem composite_of_injections_is_injection {α β γ : Type} {f : β → γ} {g : α → β}
    (hf : Function.Injective f) (hg : Function.Injective g) :
    Function.Injective (f ∘ g) := by
  intro x y h
  exact hg (hf h)