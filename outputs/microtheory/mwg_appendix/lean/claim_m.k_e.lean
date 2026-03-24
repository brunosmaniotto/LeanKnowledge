import Mathlib
open Topology

theorem claim_M_K_e (h c : ℝ) : h ≥ c ↔ -h ≤ -c := by
  constructor
  · intro hge; linarith
  · intro hle; linarith