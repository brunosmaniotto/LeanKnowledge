import Mathlib

noncomputable def support_function (L : ℕ) (K : Set (EuclideanSpace ℝ (Fin L))) (p : EuclideanSpace ℝ (Fin L)) : ℝ :=
  ⨅ x ∈ K, @inner ℝ _ _ p x