import Mathlib

theorem epimorphism_from_division_ring {K R : Type _} [DivisionRing K] [Ring R]
    (φ : K →+* R) (hφ : Function.Surjective φ) :
    (1 : R) = 0 ∨ (∃ (e : K ≃+* R), ⇑e = φ) := by
  have hker : RingHom.ker φ = ⊥ ∨ RingHom.ker φ = ⊤ := Ideal.eq_bot_or_top (RingHom.ker φ)
  rcases hker with (hker | hker)
  · have hinj : Function.Injective φ := (RingHom.injective_iff_ker_eq_bot φ).mpr hker
    let e : K ≃+* R := RingEquiv.ofBijective φ ⟨hinj, hφ⟩
    exact Or.inr ⟨e, rfl⟩
  · have h1 : (1 : K) ∈ RingHom.ker φ := by
      rw [hker]
      exact Submodule.mem_top
    rw [RingHom.mem_ker] at h1
    rw [map_one] at h1
    exact Or.inl h1