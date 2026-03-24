import Mathlib

theorem complex_plane_is_metric_space :
    (∀ z w : ℂ, 0 ≤ ‖z - w‖) ∧ (∀ z : ℂ, ‖z - z‖ = 0) ∧ (∀ z w : ℂ, ‖z - w‖ = ‖w - z‖) ∧
    (∀ z w u : ℂ, ‖z - u‖ ≤ ‖z - w‖ + ‖w - u‖) ∧ (∀ z w : ℂ, ‖z - w‖ = 0 → z = w) := by
  refine ⟨fun z w => norm_nonneg _, fun z => by simp, fun z w => norm_sub_rev _ _, ?_, ?_⟩
  · intro z w u
    calc
      ‖z - u‖ = ‖(z - w) + (w - u)‖ := by ring
      _ ≤ ‖z - w‖ + ‖w - u‖ := norm_add_le _ _
  · intro z w h
    exact sub_eq_zero.mp (norm_eq_zero.mp h)