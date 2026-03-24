import Mathlib

open Set

-- The set of all real intervals (defined as OrdConnected sets)
def intervals : Set (Set ℝ) := {s | Set.OrdConnected s}