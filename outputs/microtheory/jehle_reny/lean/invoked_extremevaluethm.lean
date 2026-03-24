import Mathlib
open Topology

theorem extreme_value_theorem
    {α : Type*} [TopologicalSpace α]
    {f : α → ℝ} {S : Set α}
    (hS : IsCompact S) (hne : S.Nonempty)
    (hf : ContinuousOn f S) :
    ∃ x ∈ S, ∀ y ∈ S, f y ≤ f x := by
  obtain ⟨x, hxS, hmax⟩ := hS.exists_isMaxOn hne hf
  exact ⟨x, hxS, fun y hy => hmax hy⟩