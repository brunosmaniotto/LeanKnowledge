import Mathlib

open AddMonoidHom

theorem int_is_add_subgroup_of_real : ∃ (S : AddSubgroup ℝ), Nonempty (ℤ ≃+ S) := by
  let f : ℤ →+ ℝ := Int.castAddHom ℝ
  have hinj : Function.Injective f := Int.cast_injective
  let S : AddSubgroup ℝ := f.range
  have : Nonempty (ℤ ≃+ S) := by
    let g : ℤ →+ S := f.rangeRestrict
    have hinj_g : Function.Injective g := by
      intro x y h
      exact hinj (congr_arg Subtype.val h)
    have hsurj_g : Function.Surjective g := by
      intro y
      rcases y with ⟨y, hy⟩
      rcases hy with ⟨x, rfl⟩
      exact ⟨x, rfl⟩
    exact ⟨AddEquiv.ofBijective g ⟨hinj_g, hsurj_g⟩⟩
  exact ⟨S, this⟩