import Mathlib

open scoped BigOperators

noncomputable def MWG.Hyperplane (N : ℕ) (p : EuclideanSpace ℝ (Fin N)) (c : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  {z | @inner ℝ _ _ p z = c}

noncomputable def MWG.HalfSpaceAbove (N : ℕ) (p : EuclideanSpace ℝ (Fin N)) (c : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  {z | @inner ℝ _ _ p z ≥ c}

noncomputable def MWG.HalfSpaceBelow (N : ℕ) (p : EuclideanSpace ℝ (Fin N)) (c : ℝ) : Set (EuclideanSpace ℝ (Fin N)) :=
  {z | @inner ℝ _ _ p z ≤ c}