import Mathlib

theorem surjective_of_comp_surjective {S₁ S₂ S₃ : Type _} (f : S₁ → S₂) (g : S₂ → S₃) :
    Function.Surjective (g ∘ f) → Function.Surjective g := by
  intro h z
  obtain ⟨x, hx⟩ := h z
  use f x
  exact hx