import Mathlib

theorem Finite_Integral_Domain_is_Galois_Field (R : Type u) [CommRing R] [Finite R] [IsDomain R] : IsField R := by
  refine IsField.mk ?_ mul_comm ?_
  · exact Nontrivial.exists_pair_ne
  · intro a ha
    let f : R → R := fun x => a * x
    have hinj : Function.Injective f := by
      intro x y h
      exact mul_left_cancel₀ ha h
    have h_surj : Function.Surjective f := Finite.surjective_of_injective hinj
    obtain ⟨x, hx⟩ := h_surj 1
    exact ⟨x, hx⟩