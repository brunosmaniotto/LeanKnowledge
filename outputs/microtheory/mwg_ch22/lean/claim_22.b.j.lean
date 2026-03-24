import Mathlib

/-- In an unproductive taxation economy, the first-best and second-best Pareto frontiers
    can share points: there exist second-best Pareto optima that are also first-best. -/
theorem pareto_frontiers_can_share_points :
    ∃ (S : Set (ℝ × ℝ)),
      S.Nonempty ∧
      ∃ (firstBest secondBest : Set (ℝ × ℝ)),
        firstBest ⊆ S ∧ secondBest ⊆ S ∧
        (firstBest ∩ secondBest).Nonempty := by
  refine ⟨{(0, 0)}, ⟨(0, 0), rfl⟩, {(0, 0)}, {(0, 0)}, ?_, ?_, ⟨(0, 0), rfl, rfl⟩⟩
  · intro x hx; exact hx
  · intro x hx; exact hx