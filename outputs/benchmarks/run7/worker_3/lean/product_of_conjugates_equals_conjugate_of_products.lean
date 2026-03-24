import Mathlib

theorem product_of_conjugates {G : Type*} [Group G] (a x y : G) :
    (a * x * a⁻¹) * (a * y * a⁻¹) = a * (x * y) * a⁻¹ := by
  group