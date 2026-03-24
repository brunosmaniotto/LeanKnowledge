import Mathlib

theorem cartesian_product_of_countable_is_countable {α β : Type _} (S : Set α) (T : Set β)
    (hS : S.Countable) (hT : T.Countable) : (S ×ˢ T).Countable :=
  Set.Countable.prod hS hT