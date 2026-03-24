import Mathlib

def homomorphism_preserves_subsemigroups {S T : Type _} [Semigroup S] [Semigroup T]
    (φ : S →ₙ* T) (S' : Subsemigroup S) : Subsemigroup T where
  carrier := φ '' (S' : Set S)
  mul_mem' := by
    intro a b ha hb
    rcases ha with ⟨a', ha', rfl⟩
    rcases hb with ⟨b', hb', rfl⟩
    exact ⟨a' * b', S'.mul_mem ha' hb', φ.map_mul a' b'⟩