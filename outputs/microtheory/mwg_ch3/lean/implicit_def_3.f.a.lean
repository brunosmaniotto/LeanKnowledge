import Mathlib

noncomputable def HalfSpace {N : ℕ} (p : EuclideanSpace ℝ (Fin N)) (c : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  {x | @inner ℝ _ _ p x ≥ c}

noncomputable def Hyperplane {N : ℕ} (p : EuclideanSpace ℝ (Fin N)) (c : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  {x | @inner ℝ _ _ p x = c}