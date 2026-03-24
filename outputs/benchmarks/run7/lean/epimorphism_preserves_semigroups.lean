import Mathlib

def epimorphism_preserves_semigroup {S T : Type} [Semigroup S] [Mul T] (φ : S →ₙ* T) (hφ : Function.Surjective φ) :
    Semigroup T :=
  { mul_assoc := by
      intro a b c
      rcases hφ a with ⟨x, rfl⟩
      rcases hφ b with ⟨y, rfl⟩
      rcases hφ c with ⟨z, rfl⟩
      simp only [← φ.map_mul, mul_assoc] }