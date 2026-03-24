import Mathlib
open Set
open Real
open Filter
open Topology

noncomputable section

def topologistsSineCurve : Set (ℝ × ℝ) :=
  { p | (0 < p.1 ∧ p.2 = Real.sin (1 / p.1)) ∨ (p.1 = 0 ∧ p.2 ∈ Set.Icc (-1 : ℝ) 1) }