import Mathlib

open Bornology
open Metric

theorem heine_borel (C : Set ℝ) : IsCompact C ↔ IsClosed C ∧ IsBounded C :=
  isCompact_iff_isClosed_bounded