import Mathlib

theorem exists_max_and_min_on_Icc {a b : ℝ} (hab : a ≤ b) {f : ℝ → ℝ} (hf : ContinuousOn f (Set.Icc a b)) :
    ∃ x_max ∈ Set.Icc a b, ∃ x_min ∈ Set.Icc a b, (∀ y ∈ Set.Icc a b, f y ≤ f x_max) ∧ (∀ y ∈ Set.Icc a b, f x_min ≤ f y) := by
  have hcomp : IsCompact (Set.Icc a b) := isCompact_Icc
  have hne : (Set.Icc a b).Nonempty := Set.nonempty_Icc.mpr hab
  obtain ⟨x_max, hx_max, hmax⟩ := hcomp.exists_isMaxOn hne hf
  obtain ⟨x_min, hx_min, hmin⟩ := hcomp.exists_isMinOn hne hf
  exact ⟨x_max, hx_max, x_min, hx_min, hmax, hmin⟩