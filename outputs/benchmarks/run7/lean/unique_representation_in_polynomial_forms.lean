import Mathlib

theorem unique_representation_in_polynomial_forms (R : Type) [CommRing R] (D : Type) [CommRing D] [IsDomain D]
    (i : D →+* R) (X : R) (h_trans : ∀ p : Polynomial D, Polynomial.eval₂ i X p = 0 → p = 0)
    (f : R) (hf : f ∈ RingHom.range (Polynomial.eval₂RingHom i X)) :
    ∃! p : Polynomial D, Polynomial.eval₂ i X p = f := by
  rcases hf with ⟨p, rfl⟩
  have eval₂_injective : Function.Injective (Polynomial.eval₂ i X) := by
    intro p q h
    have h_sub : Polynomial.eval₂ i X (p - q) = 0 := by
      rw [Polynomial.eval₂_sub, h, sub_self]
    have := h_trans (p - q) h_sub
    exact sub_eq_zero.mp this
  refine ⟨p, rfl, fun q hq => eval₂_injective hq⟩