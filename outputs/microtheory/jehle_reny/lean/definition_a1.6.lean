import Mathlib

open Set Topology
open Topology

/-- A set S in ℝ^n is closed if its complement Sᶜ is open. -/
abbrev Definition_A1_6 {n : ℕ} (S : Set (EuclideanSpace ℝ (Fin n))) : Prop :=
  IsClosed S