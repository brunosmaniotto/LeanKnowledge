import Mathlib

theorem continuous_on_closed_interval_bounded {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b)) : ∃ M, ∀ x ∈ Set.Icc a b, |f x| ≤ M := by
  -- `Set.Icc a b` is compact in ℝ
  have h_compact : IsCompact (Set.Icc a b) := isCompact_Icc
  -- The image of a compact set under a continuous function is compact
  have h_comp_image : IsCompact (f '' Set.Icc a b) :=
    h_compact.image_of_continuousOn hf
  -- A compact set in a metric space is bounded
  have h_bdd : Bornology.IsBounded (f '' Set.Icc a b) :=
    h_comp_image.isBounded
  -- Obtain a constant C that bounds the norm of every element in the image
  rcases h_bdd.exists_norm_le with ⟨C, hC⟩
  refine ⟨C, fun x hx => ?_⟩
  -- For each x in [a, b], f(x) is in the image
  have h_mem : f x ∈ f '' Set.Icc a b := Set.mem_image_of_mem f hx
  -- Therefore ‖f x‖ ≤ C
  have h_norm : ‖f x‖ ≤ C := hC (f x) h_mem
  -- In ℝ, the norm is the absolute value
  rw [Real.norm_eq_abs] at h_norm
  exact h_norm