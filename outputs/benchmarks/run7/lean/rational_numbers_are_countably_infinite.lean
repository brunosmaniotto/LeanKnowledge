import Mathlib

theorem rat_countably_infinite : Countable ℚ ∧ Infinite ℚ := by
  constructor
  · infer_instance
  · exact Infinite.of_injective (fun n : ℕ => (n : ℚ)) Nat.cast_injective