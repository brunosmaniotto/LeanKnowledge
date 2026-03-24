import Mathlib

variable {S T : Type}

def many_to_one (R : Set (S × T)) : Prop :=
  ∀ (x : S) (y₁ y₂ : T), (x, y₁) ∈ R → (x, y₂) ∈ R → y₁ = y₂