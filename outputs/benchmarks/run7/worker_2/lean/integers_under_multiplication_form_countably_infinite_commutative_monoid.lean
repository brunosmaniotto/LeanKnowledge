import Mathlib

theorem int_mul_countably_infinite_comm_monoid :
    (∀ a b : ℤ, a * b = b * a) ∧
    (∃ e : ℤ, ∀ a : ℤ, e * a = a ∧ a * e = a) ∧
    (∀ a b c : ℤ, (a * b) * c = a * (b * c)) ∧
    Countable ℤ ∧
    Infinite ℤ := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact mul_comm
  · exact ⟨1, fun a => ⟨one_mul a, mul_one a⟩⟩
  · exact mul_assoc
  · infer_instance
  · infer_instance