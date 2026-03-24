import Mathlib.GroupTheory.OrderOfElement

theorem Element_of_Finite_Group_is_of_Finite_Order (G : Type*) [Group G] [Fintype G] (g : G) : IsOfFinOrder g := by
  apply isOfFinOrder_of_finite