import Mathlib

section

variable {S T : Type*} (op : T → T → T) (h_comm : ∀ a b, op a b = op b a)

/-- The pointwise operation on functions induced by a binary operation on the codomain. -/
def pointwiseOp (f g : S → T) : S → T := fun x => op (f x) (g x)