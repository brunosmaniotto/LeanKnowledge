import Mathlib

theorem square_is_sum_of_two_rectangles {R : Type*} [CommSemiring R] (x y : R) :
    (x + y)^2 = (x + y) * x + (x + y) * y := by
  ring