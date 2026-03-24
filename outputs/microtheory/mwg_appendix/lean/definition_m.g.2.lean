import Mathlib

noncomputable abbrev MWG.ConvexHull {N : ℕ} (B : Set (Fin N → ℝ)) : Set (Fin N → ℝ) :=
  convexHull ℝ B