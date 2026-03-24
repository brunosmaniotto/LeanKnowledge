import Mathlib

open AddMonoidHom

theorem rationals_are_normal_add_subgroup_of_reals : ∃ (H : AddSubgroup ℝ) (f : ℚ →+ ℝ),
    Function.Injective f ∧ H = AddMonoidHom.range f ∧ H.Normal := by
  let f : ℚ →+ ℝ := (algebraMap ℚ ℝ).toAddMonoidHom
  have hinj : Function.Injective f := Rat.cast_injective
  refine ⟨AddMonoidHom.range f, f, hinj, rfl, inferInstance⟩