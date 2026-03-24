import Mathlib

theorem int_countably_infinite : Infinite ℤ ∧ Countable ℤ := by
  constructor <;> infer_instance