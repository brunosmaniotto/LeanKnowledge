import Mathlib

theorem Order_of_Conjugate_Element_equals_Order_of_Element {G : Type*} [Group G] (a x : G) :
  orderOf (x * a * x⁻¹) = orderOf a :=
(MulAut.conj x).orderOf_eq a