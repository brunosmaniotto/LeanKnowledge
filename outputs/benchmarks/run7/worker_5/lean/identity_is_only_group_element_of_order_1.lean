import Mathlib

theorem identity_is_only_element_of_order_one {G : Type*} [Group G] (g : G) : orderOf g = 1 ↔ g = 1 :=
  orderOf_eq_one_iff