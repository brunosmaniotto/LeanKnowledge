import Mathlib

theorem comp_perm {α : Type _} {S : Set α} (f g : S → S) (hf : Function.Bijective f) (hg : Function.Bijective g) :
    Function.Bijective (g ∘ f) :=
  Function.Bijective.comp hg hf