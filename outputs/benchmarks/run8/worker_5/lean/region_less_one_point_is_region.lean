import Mathlib

open Set

variable {M : Type} [MetricSpace M]

/-- A region is a nonempty, open, path-connected set. -/
def IsRegion (s : Set M) : Prop := s.Nonempty ∧ IsOpen s ∧ IsPathConnected s