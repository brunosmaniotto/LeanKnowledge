import Mathlib

/-- The greatest lower bound (g.l.b.) of a set S ⊂ ℝ is the largest lower bound of S. -/
noncomputable abbrev Def_GLB (S : Set ℝ) : ℝ := sInf S