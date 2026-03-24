import Mathlib

namespace Nat

theorem add_sub_max_eq_min (a b : ℕ) : a + b - max a b = min a b := by
  calc
    a + b - max a b = (max a b + min a b) - max a b := by rw [max_add_min]
    _ = min a b := by rw [Nat.add_sub_cancel_left]

end Nat

namespace Int