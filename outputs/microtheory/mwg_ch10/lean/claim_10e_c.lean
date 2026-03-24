import Mathlib

open MeasureTheory intervalIntegral
open Topology

noncomputable section

def marshallianSurplus (P C' : ℝ → ℝ) (S₀ : ℝ) (x : ℝ) : ℝ :=
  S₀ + ∫ s in (0 : ℝ)..x, (P s - C' s)