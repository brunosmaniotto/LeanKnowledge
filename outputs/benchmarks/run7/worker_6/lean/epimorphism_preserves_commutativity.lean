import Mathlib

theorem epimorphism_preserves_commutativity {S T : Type*} [Mul S] [Mul T] (φ : S →ₙ* T)
    (hφ : Function.Surjective φ) (h_comm : ∀ x y : S, x * y = y * x) : ∀ u v : T, u * v = v * u := by
  intro u v
  rcases hφ u with ⟨x, rfl⟩
  rcases hφ v with ⟨y, rfl⟩
  calc
    φ x * φ y = φ (x * y) := by rw [← φ.map_mul]
    _ = φ (y * x) := by rw [h_comm x y]
    _ = φ y * φ x := by rw [φ.map_mul]