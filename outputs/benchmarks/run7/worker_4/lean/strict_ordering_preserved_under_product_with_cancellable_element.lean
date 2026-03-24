import Mathlib

variable {S : Type*} [Semigroup S] [PartialOrder S]
  [CovariantClass S S (· * ·) (· ≤ ·)] [CovariantClass S S (Function.swap (· * ·)) (· ≤ ·)]

theorem mul_lt_mul_of_cancel_right {x y z : S} (hz : Function.Injective (· * z)) (hlt : x < y) :
    x * z < y * z := by
  have hle : x ≤ y := hlt.le
  have hne : x ≠ y := hlt.ne
  refine lt_of_le_of_ne (mul_le_mul_right' hle z) fun heq => ?_
  apply hne
  exact hz heq