import Mathlib

theorem right_operation_properties (S : Type) (op : S → S → S) (h : ∀ x y, op x y = y) :
    (∀ a b c, op (op a b) c = op a (op b c)) ∧ (∀ a, ∀ x, op a x = x) := by
  constructor
  · intro a b c
    rw [h, h, h]
  · intro a x
    rw [h]