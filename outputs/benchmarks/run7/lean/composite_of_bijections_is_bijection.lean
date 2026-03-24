import Mathlib

theorem composite_bijection {α β γ : Type*} (g : α → β) (f : β → γ)
    (hg : Function.Bijective g) (hf : Function.Bijective f) :
    Function.Bijective (f ∘ g) := by
  -- `hg` and `hf` are each a conjunction of injectivity and surjectivity
  rcases hg with ⟨hg_inj, hg_surj⟩
  rcases hf with ⟨hf_inj, hf_surj⟩
  constructor
  · exact Function.Injective.comp hf_inj hg_inj
  · exact Function.Surjective.comp hf_surj hg_surj