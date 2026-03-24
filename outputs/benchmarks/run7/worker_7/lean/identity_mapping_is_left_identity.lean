import Mathlib

variable {S T : Type} (f : S → T)

theorem identity_comp_left : (id : T → T) ∘ f = f := by
  ext x
  simp