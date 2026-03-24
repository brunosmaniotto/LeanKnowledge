import Mathlib

theorem subset_linearIndependent {R M : Type _} [Semiring R] [AddCommMonoid M] [Module R M]
    {ι : Type _} {s t : Set M} (hst : t ⊆ s) (hs : LinearIndependent R ((↑) : s → M)) :
    LinearIndependent R ((↑) : t → M) := by
  -- Define the inclusion map from t to s
  let φ : t → s := fun x => ⟨x, hst x.prop⟩
  -- This map is injective
  have hφ : Function.Injective φ := by
    intro x y h
    exact Subtype.ext (Subtype.mk.inj h)
  -- Compose the original linear independent family with this injection
  exact hs.comp φ hφ