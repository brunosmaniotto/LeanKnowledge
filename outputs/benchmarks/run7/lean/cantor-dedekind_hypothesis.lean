import Mathlib.Data.Real.Basic

theorem cantor_dedekind_hypothesis : ∃ f : ℝ → ℝ, Function.Bijective f := by
  exact ⟨id, Function.bijective_id⟩