import Mathlib

variable {S : Type _} [Semigroup S]

theorem restriction_associative (T : Set S) (h_mul : ∀ a b, a ∈ T → b ∈ T → a * b ∈ T) :
    let mul_T : T → T → T := fun a b => ⟨a.1 * b.1, h_mul a.1 b.1 a.2 b.2⟩
    ∀ a b c : T, mul_T (mul_T a b) c = mul_T a (mul_T b c) := by
  intro mul_T a b c
  ext
  simp [mul_T]
  exact mul_assoc (a : S) (b : S) (c : S)