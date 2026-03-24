import Mathlib

open Function

theorem inverse_of_composite_bijection {α β γ : Type*} (f : α → β) (g : β → γ)
    (hf : Bijective f) (hg : Bijective g) :
    let e_f := Equiv.ofBijective f hf
    let e_g := Equiv.ofBijective g hg
    let e_comp := Equiv.ofBijective (g ∘ f) (Bijective.comp hg hf)
    e_comp.symm = e_g.symm.trans e_f.symm ∧ Bijective (e_g.symm.trans e_f.symm) := by
  intro e_f e_g e_comp
  have h_eq : e_comp = e_f.trans e_g := by
    ext x
    simp [e_f, e_g, e_comp, Equiv.trans_apply]
  have h_symm : (e_f.trans e_g).symm = e_g.symm.trans e_f.symm := by
    ext x
    simp [Equiv.trans_apply, Equiv.symm_apply_apply]
  constructor
  · calc
      e_comp.symm = (e_f.trans e_g).symm := by rw [h_eq]
      _ = e_g.symm.trans e_f.symm := h_symm
  · exact (e_g.symm.trans e_f.symm).bijective