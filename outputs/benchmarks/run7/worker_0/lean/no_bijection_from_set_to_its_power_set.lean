import Mathlib

theorem no_bijection_to_power_set (S : Type _) : ¬ ∃ (f : S → Set S), Function.Bijective f := by
  rintro ⟨f, hbij⟩
  have h_surj : Function.Surjective f := hbij.surjective
  exact Function.cantor_surjective f h_surj