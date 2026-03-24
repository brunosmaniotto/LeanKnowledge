import Mathlib

open Complex
open Set

def CircleSet (c : ℂ) (R : ℝ) : Set ℂ := Set.range (circleMap c R)