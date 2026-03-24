import Mathlib

variable {R G H : Type*} [Ring R] [AddCommGroup G] [AddCommGroup H] [Module R G] [Module R H]

theorem linear_transformation_submodule_properties (φ : G →ₗ[R] H) :
    (∀ (M : Submodule R G), ∃ (S : Submodule R H), S = Submodule.map φ M) ∧
    (∀ (N : Submodule R H), ∃ (T : Submodule R G), T = Submodule.comap φ N) ∧
    (∃ (S : Submodule R H), S = ⊤) ∧
    (∃ (T : Submodule R G), T = LinearMap.ker φ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro M
    exact ⟨Submodule.map φ M, rfl⟩
  · intro N
    exact ⟨Submodule.comap φ N, rfl⟩
  · exact ⟨⊤, rfl⟩
  · exact ⟨LinearMap.ker φ, rfl⟩