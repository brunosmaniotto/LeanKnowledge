import Mathlib

theorem Nat.isCommSemiring :
    (∀ a b : ℕ, a + b = b + a) ∧
    (∀ a b c : ℕ, (a + b) + c = a + (b + c)) ∧
    (∀ a : ℕ, 0 + a = a) ∧
    (∀ a : ℕ, a + 0 = a) ∧
    (∀ a b : ℕ, a * b = b * a) ∧
    (∀ a b c : ℕ, (a * b) * c = a * (b * c)) ∧
    (∀ a : ℕ, 1 * a = a) ∧
    (∀ a : ℕ, a * 1 = a) ∧
    (∀ a b c : ℕ, a * (b + c) = a * b + a * c) ∧
    (∀ a b c : ℕ, (a + b) * c = a * c + b * c) := by
  refine ⟨Nat.add_comm, Nat.add_assoc, Nat.zero_add, Nat.add_zero, Nat.mul_comm, Nat.mul_assoc, Nat.one_mul, Nat.mul_one, Nat.mul_add, Nat.add_mul⟩