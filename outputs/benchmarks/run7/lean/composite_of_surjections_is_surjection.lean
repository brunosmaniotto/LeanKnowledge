import Mathlib

open Function

theorem surjective_comp {α β γ : Type _} {f : α → β} {g : β → γ} 
    (hg : Surjective g) (hf : Surjective f) : Surjective (g ∘ f) := by
  intro z
  obtain ⟨y, hy⟩ := hg z
  obtain ⟨x, hx⟩ := hf y
  exact ⟨x, by simp [hx, hy]⟩