import Mathlib

noncomputable section

open Set
open Metric

-- Define ℝ³ as Euclidean space over ℝ with dimension 3
abbrev R3 : Type := EuclideanSpace ℝ (Fin 3)

-- Unit ball centered at origin with radius 1
def unitBall : Set R3 := closedBall (0 : R3) 1

-- Alternative formulation using open ball