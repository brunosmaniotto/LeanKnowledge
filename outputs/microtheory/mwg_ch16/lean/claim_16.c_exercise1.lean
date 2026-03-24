import Mathlib

open Set Filter Topology

theorem claim_16C_exercise1
    {L : ℕ}
    {X : Set (EuclideanSpace ℝ (Fin L))}
    (hne : X.Nonempty)
    (hcpt : IsCompact X)
    (u : EuclideanSpace ℝ (Fin L) → ℝ)
    (hu : ContinuousOn u X) :
    ∃ x ∈ X, ∀ y ∈ X, u y ≤ u x := by
  obtain ⟨x, hxX, hmax⟩ := hcpt.exists_isMaxOn hne hu
  exact ⟨x, hxX, fun y hy => hmax hy⟩