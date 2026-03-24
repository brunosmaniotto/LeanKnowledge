import Mathlib

/-- The Baire Category Theorem: a complete metric space is a Baire space. -/
theorem baire_category_theorem (M : Type u) [MetricSpace M] [CompleteSpace M] : BaireSpace M :=
  inferInstance