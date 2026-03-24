import Mathlib

theorem epimorphism_preserves_identity {S T : Type*} [MulOneClass S] [Mul T] (φ : S → T)
    (hφ_mul : ∀ a b, φ (a * b) = φ a * φ b) (hφ_surj : Function.Surjective φ) :
    ∀ t, t * φ 1 = t ∧ φ 1 * t = t := by
  intro t
  obtain ⟨s, rfl⟩ := hφ_surj t
  constructor
  · rw [← hφ_mul, mul_one]
  · rw [← hφ_mul, one_mul]