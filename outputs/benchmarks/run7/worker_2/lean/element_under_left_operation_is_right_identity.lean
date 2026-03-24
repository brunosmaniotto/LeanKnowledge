import Mathlib

theorem left_op_is_semigroup_and_all_right_identities (S : Type _) :
    let op : S → S → S := fun x y => x
    (∀ a b c, op (op a b) c = op a (op b c)) ∧ (∀ a x, op x a = x) := by
  intro op
  constructor
  · intro a b c
    rfl
  · intro a x
    rfl