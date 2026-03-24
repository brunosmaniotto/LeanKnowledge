import Mathlib

variable {α : Type _} [MetricSpace α] (x y : α) (ε : ℝ)

theorem exists_ball_subset_ball (h : y ∈ Metric.ball x ε) : ∃ δ > 0, Metric.ball y δ ⊆ Metric.ball x ε := by
  have h_dist : dist y x < ε := h
  refine ⟨ε - dist y x, by linarith, ?_⟩
  intro z hz
  rw [Metric.mem_ball] at hz
  rw [Metric.mem_ball]
  calc
    dist z x ≤ dist z y + dist y x := dist_triangle z y x
    _ < (ε - dist y x) + dist y x := by linarith
    _ = ε := by ring