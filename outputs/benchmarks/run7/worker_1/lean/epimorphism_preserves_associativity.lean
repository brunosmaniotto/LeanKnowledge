import Mathlib

theorem epimorphism_preserves_associativity {S T : Type*} [Mul S] [Mul T] (φ : S → T)
    (hφ_hom : ∀ x y : S, φ (x * y) = φ x * φ y) (hφ_surj : Function.Surjective φ)
    (hS_assoc : ∀ x y z : S, (x * y) * z = x * (y * z)) : ∀ u v w : T, (u * v) * w = u * (v * w) := by
  intro u v w
  rcases hφ_surj u with ⟨x, rfl⟩
  rcases hφ_surj v with ⟨y, rfl⟩
  rcases hφ_surj w with ⟨z, rfl⟩
  calc
    (φ x * φ y) * φ z = φ (x * y) * φ z := by rw [← hφ_hom]
    _ = φ ((x * y) * z) := by rw [← hφ_hom]
    _ = φ (x * (y * z)) := by rw [hS_assoc]
    _ = φ x * φ (y * z) := by rw [hφ_hom]
    _ = φ x * (φ y * φ z) := by rw [hφ_hom]