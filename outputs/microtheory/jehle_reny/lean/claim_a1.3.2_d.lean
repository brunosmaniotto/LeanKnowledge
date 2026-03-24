import Mathlib

/-- The Brouwer fixed-point theorem does not guarantee uniqueness:
    a continuous f : [0,1] → [0,1] can have multiple fixed points. -/
theorem brouwer_nonuniqueness :
    ∃ f : Set.Icc (0 : ℝ) 1 → Set.Icc (0 : ℝ) 1,
      Continuous f ∧
      ∃ x y : Set.Icc (0 : ℝ) 1, x ≠ y ∧ f x = x ∧ f y = y := by
  refine ⟨id, continuous_id, ?_⟩
  refine ⟨⟨0, by norm_num⟩, ⟨1, by norm_num⟩, ?_, rfl, rfl⟩
  simp [Subtype.ext_iff]