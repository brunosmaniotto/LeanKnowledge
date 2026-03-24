import Mathlib

theorem pointwise_associative {S T : Type*} (op : T → T → T) (h_assoc : ∀ a b c, op (op a b) c = op a (op b c)) :
    let pointwise := fun (f g : S → T) (x : S) ↦ op (f x) (g x)
    ∀ (f g h : S → T), pointwise (pointwise f g) h = pointwise f (pointwise g h) := by
  intro pointwise f g h
  ext x
  simp [pointwise]
  exact h_assoc (f x) (g x) (h x)