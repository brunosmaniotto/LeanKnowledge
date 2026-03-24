import Mathlib

theorem injection_is_bijection_iff_inverse_injection (S T : Type*) (φ : S → T) (h_inj : Function.Injective φ) :
    Function.Bijective φ ↔ ∃ ψ : T → S, Function.Injective ψ ∧ Function.LeftInverse ψ φ ∧ Function.RightInverse ψ φ := by
  constructor
  · intro h_bij
    have h_surj : Function.Surjective φ := h_bij.2
    let e : S ≃ T := Equiv.ofBijective φ ⟨h_inj, h_surj⟩
    use e.symm
    refine ⟨e.symm.injective, e.symm_apply_apply, e.apply_symm_apply⟩
  · rintro ⟨ψ, ψ_inj, h_left, h_right⟩
    exact ⟨h_inj, fun y => ⟨ψ y, h_right y⟩⟩