import Mathlib

theorem comp_inv_eq_id {S T : Type*} (f : S → T) (hf : Function.Bijective f) :
    ((Equiv.ofBijective f hf).symm : T → S) ∘ f = id ∧ f ∘ (Equiv.ofBijective f hf).symm = id := by
  let e := Equiv.ofBijective f hf
  have h1 : e.symm ∘ f = id := by
    ext x
    exact e.symm_apply_apply x
  have h2 : f ∘ e.symm = id := by
    ext y
    exact e.apply_symm_apply y
  exact ⟨h1, h2⟩