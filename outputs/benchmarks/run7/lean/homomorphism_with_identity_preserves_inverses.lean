import Mathlib

theorem hom_preserves_inv {S T : Type} [MulOneClass S] [MulOneClass T]
    (φ : S → T) (h_mul : ∀ x y, φ (x * y) = φ x * φ y) (h_one : φ (1 : S) = (1 : T))
    (x : S) (xinv : S) (hleft : x * xinv = 1) (hright : xinv * x = 1) :
    φ x * φ xinv = (1 : T) ∧ φ xinv * φ x = (1 : T) := by
  constructor
  · calc
      φ x * φ xinv = φ (x * xinv) := by rw [h_mul]
      _ = φ (1 : S) := by rw [hleft]
      _ = (1 : T) := by rw [h_one]
  · calc
      φ xinv * φ x = φ (xinv * x) := by rw [h_mul]
      _ = φ (1 : S) := by rw [hright]
      _ = (1 : T) := by rw [h_one]