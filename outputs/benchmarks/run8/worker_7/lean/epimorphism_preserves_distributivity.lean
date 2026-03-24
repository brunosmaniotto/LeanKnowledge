import Mathlib

variable {R1 R2 : Type*} (add1 : R1 → R1 → R1) (mul1 : R1 → R1 → R1)
  (add2 : R2 → R2 → R2) (mul2 : R2 → R2 → R2) (φ : R1 → R2)

theorem left_distrib_preserved
    (h_add : ∀ a b, φ (add1 a b) = add2 (φ a) (φ b))
    (h_mul : ∀ a b, φ (mul1 a b) = mul2 (φ a) (φ b))
    (h_surj : Function.Surjective φ)
    (h_left_distrib1 : ∀ a b c, mul1 a (add1 b c) = add1 (mul1 a b) (mul1 a c)) :
    ∀ x y z, mul2 x (add2 y z) = add2 (mul2 x y) (mul2 x z) := by
  intro x y z
  rcases h_surj x with ⟨a, rfl⟩
  rcases h_surj y with ⟨b, rfl⟩
  rcases h_surj z with ⟨c, rfl⟩
  calc
    mul2 (φ a) (add2 (φ b) (φ c)) = mul2 (φ a) (φ (add1 b c)) := by rw [h_add]
    _ = φ (mul1 a (add1 b c)) := by rw [h_mul]
    _ = φ (add1 (mul1 a b) (mul1 a c)) := by rw [h_left_distrib1]
    _ = add2 (φ (mul1 a b)) (φ (mul1 a c)) := by rw [h_add]
    _ = add2 (mul2 (φ a) (φ b)) (mul2 (φ a) (φ c)) := by rw [h_mul, h_mul]