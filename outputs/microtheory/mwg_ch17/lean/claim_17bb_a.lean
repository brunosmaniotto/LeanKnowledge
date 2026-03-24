import Mathlib

noncomputable section

theorem expenditure_minimization_better_continuity :
    ∃ (u : ℝ → ℝ) (cost : ℝ → ℝ),
      (∀ y : ℝ, u y ≥ u 0 → cost 0 ≤ cost y) ∧
      ¬(∀ y : ℝ, cost y ≤ cost 0 → u y ≤ u 0) := by
  refine ⟨fun x => x, fun _ => (1 : ℝ), ?_, ?_⟩
  · intro y _
    simp
  · push_neg
    exact ⟨1, le_refl _, by norm_num⟩

end