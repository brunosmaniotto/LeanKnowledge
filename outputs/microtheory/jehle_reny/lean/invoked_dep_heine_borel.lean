import Mathlib

open Set Metric Bornology
open Topology

theorem heine_borel (n : ℕ) (s : Set (EuclideanSpace ℝ (Fin n))) :
    IsCompact s ↔ IsClosed s ∧ IsBounded s :=
  isCompact_iff_isClosed_bounded