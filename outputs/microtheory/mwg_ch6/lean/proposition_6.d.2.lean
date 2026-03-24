import Mathlib

open MeasureTheory Set

noncomputable def intCDF (F : ℝ → ℝ) (x : ℝ) : ℝ := ∫ t in Icc 0 x, F t

def SOSD (F G : ℝ → ℝ) : Prop :=
  ∀ u : ℝ → ℝ, ConcaveOn ℝ univ u →
    ∫ t in Icc 0 1, u t * F t ≥ ∫ t in Icc 0 1, u t * G t