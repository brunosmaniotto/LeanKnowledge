import Mathlib

theorem Nat.add_comm_monoid_properties :
    (∀ a b c : ℕ, a + b + c = a + (b + c)) ∧
    (∀ a : ℕ, 0 + a = a) ∧
    (∀ a : ℕ, a + 0 = a) ∧
    (∀ a b : ℕ, a + b = b + a) := by
  exact ⟨Nat.add_assoc, Nat.zero_add, Nat.add_zero, Nat.add_comm⟩