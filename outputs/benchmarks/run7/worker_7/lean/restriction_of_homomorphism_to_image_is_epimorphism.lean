import Mathlib

theorem restriction_of_homomorphism_to_image_is_epimorphism {M N : Type _} [Monoid M] [Monoid N]
    (φ : M →* N) : ∃ (R : Submonoid N) (ψ : M →* R), R = MonoidHom.mrange φ ∧ Function.Surjective ψ :=
  ⟨MonoidHom.mrange φ, MonoidHom.mrangeRestrict φ, rfl, MonoidHom.mrangeRestrict_surjective φ⟩