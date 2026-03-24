import Mathlib

open Metric

theorem continuous_iff_metric_continuous {A1 A2 : Type _} [MetricSpace A1] [MetricSpace A2] (f : A1 → A2) :
    Continuous f ↔ ∀ x, ∀ ε > 0, ∃ δ > 0, ∀ y, dist x y < δ → dist (f x) (f y) < ε := by
  rw [continuous_iff]
  constructor
  · intro H x ε hε
    rcases H x ε hε with ⟨δ, hδ, h⟩
    exact ⟨δ, hδ, fun y hy => by rw [dist_comm (f x) (f y)]; exact h y (by rwa [dist_comm] at hy)⟩
  · intro H x ε hε
    rcases H x ε hε with ⟨δ, hδ, h⟩
    exact ⟨δ, hδ, fun y hy => by rw [dist_comm (f y) (f x)]; exact h y (by rwa [dist_comm] at hy)⟩