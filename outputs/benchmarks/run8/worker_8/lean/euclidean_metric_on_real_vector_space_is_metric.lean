import Mathlib

theorem euclidean_metric_is_metric (n : ℕ) :
    ∀ x y : EuclideanSpace ℝ (Fin n),
      dist x y = dist y x ∧
      (dist x y = 0 ↔ x = y) ∧
      ∀ z, dist x z ≤ dist x y + dist y z := by
  intro x y
  exact ⟨dist_comm x y, dist_eq_zero, fun z => dist_triangle x y z⟩