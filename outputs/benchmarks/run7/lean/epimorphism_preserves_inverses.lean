import Mathlib

theorem epimorphism_preserves_inverses {M N : Type _} [MulOneClass M] [MulOneClass N] (φ : M →* N)
    (hφ : Function.Surjective φ) (x : M) (inv_x : M) (h1 : x * inv_x = 1) (h2 : inv_x * x = 1) :
    φ x * φ inv_x = 1 ∧ φ inv_x * φ x = 1 := by
  constructor
  · calc
      φ x * φ inv_x = φ (x * inv_x) := by rw [φ.map_mul]
      _ = φ 1 := by rw [h1]
      _ = 1 := φ.map_one
  · calc
      φ inv_x * φ x = φ (inv_x * x) := by rw [φ.map_mul]
      _ = φ 1 := by rw [h2]
      _ = 1 := φ.map_one