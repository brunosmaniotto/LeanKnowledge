import Mathlib

variable {S T : Type*}

-- Define relation composition
def rel_comp (R₁ : S → T → Prop) (R₂ : T → U → Prop) : S → U → Prop :=
  fun a c => ∃ b, R₁ a b ∧ R₂ b c

-- Define relation inverse