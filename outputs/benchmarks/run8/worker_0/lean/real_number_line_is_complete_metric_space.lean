import Mathlib

/-- The real number line ℝ with the Euclidean metric is a complete metric space. -/
theorem real_complete_metric_space : CompleteSpace ℝ := by
  infer_instance