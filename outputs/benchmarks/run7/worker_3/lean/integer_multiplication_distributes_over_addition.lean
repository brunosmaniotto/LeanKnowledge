import Mathlib

theorem integer_multiplication_distributes_over_addition :
    (∀ x y z : ℤ, x * (y + z) = x * y + x * z) ∧ (∀ x y z : ℤ, (y + z) * x = y * x + z * x) :=
  ⟨Int.mul_add, λ x y z => Int.add_mul y z x⟩