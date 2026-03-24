import Mathlib

def Signal.AtLeastAsInformative {S R R' : Type*} (σ : S → R) (σ' : S → R') : Prop :=
  ∀ s₁ s₂ : S, σ s₁ ≠ σ s₂ → σ' s₁ ≠ σ' s₂