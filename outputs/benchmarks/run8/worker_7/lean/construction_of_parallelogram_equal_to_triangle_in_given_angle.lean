import Mathlib

noncomputable section

open Real
open EuclideanSpace

def cross (v w : EuclideanSpace ℝ (Fin 2)) : ℝ := v 0 * w 1 - v 1 * w 0