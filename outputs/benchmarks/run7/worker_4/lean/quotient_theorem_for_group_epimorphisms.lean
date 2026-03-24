import Mathlib

open QuotientGroup

theorem quotient_theorem_for_group_epimorphisms {G H : Type*} [Group G] [Group H] (φ : G →* H)
    (h_surj : Function.Surjective φ) : ∃! ψ : G ⧸ φ.ker ≃* H, ψ.toMonoidHom.comp (mk' φ.ker) = φ := by
  set ψ0 := quotientKerEquivOfSurjective φ h_surj
  have h_comp : ψ0.toMonoidHom.comp (mk' φ.ker) = φ := by
    ext g
    simp [ψ0, quotientKerEquivOfSurjective, mk']
  refine ⟨ψ0, h_comp, ?_⟩
  intro ψ hψ
  apply MulEquiv.ext
  intro x
  obtain ⟨g, rfl⟩ := mk'_surjective φ.ker x
  have h1 : ψ (mk' φ.ker g) = φ g := by
    have := MonoidHom.ext_iff.mp hψ g
    exact this
  have h2 : ψ0 (mk' φ.ker g) = φ g := by
    have := MonoidHom.ext_iff.mp h_comp g
    exact this
  rw [h1, h2]