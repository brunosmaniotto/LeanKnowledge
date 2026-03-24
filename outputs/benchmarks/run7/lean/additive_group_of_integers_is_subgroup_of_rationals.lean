import Mathlib

theorem int_is_subgroup_of_rat : ∃ (f : ℤ →+ ℚ), Function.Injective f := by
  refine ⟨Int.castAddHom ℚ, ?_⟩
  intro x y h
  exact Int.cast_injective h