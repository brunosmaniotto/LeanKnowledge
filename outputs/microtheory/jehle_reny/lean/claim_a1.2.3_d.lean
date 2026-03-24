import Mathlib

theorem claim_A1_2_3_d {D R : Type*} (f : D → R) (hf : Function.Bijective f) :
    ∃ g : R → D, Function.Bijective g := by
  exact ⟨(Equiv.ofBijective f hf).symm, (Equiv.ofBijective f hf).symm.bijective⟩