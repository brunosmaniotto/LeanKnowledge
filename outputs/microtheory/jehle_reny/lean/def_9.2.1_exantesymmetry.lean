import Mathlib

open MeasureTheory Set
open Topology

/-- Buyers are ex ante symmetric if all buyers' value distributions are identical.
    Each buyer i has a distribution f_i on [0,1], and symmetry means f_i = f for all i. -/
structure ExAnteSymmetricBuyers (N : ℕ) where
  /-- The common distribution density on [0,1] -/
  f : ℝ → ℝ
  /-- Each buyer's individual distribution density on [0,1] -/
  f_i : Fin N → ℝ → ℝ
  /-- All buyers share the same distribution -/
  symmetric : ∀ i : Fin N, ∀ v : ℝ, v ∈ Icc (0 : ℝ) 1 → f_i i v = f v