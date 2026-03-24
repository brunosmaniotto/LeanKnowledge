import Mathlib

open Set
open Topology

/-- MWG Definition A1.12: A sequence in ℝⁿ is a function from an infinite subset
    of positive integers into ℝⁿ. We denote a sequence by
  xᵏ_{k∈I}. -/
structure MWG.valueFunction (n : ℕ) where
  /-- The index set I, a subset of positive integers -/
  indexSet : Set ℕ
  /-- All indices are positive -/
  pos : ∀ k ∈ indexSet, 0 < k
  /-- The index set is infinite -/
  infinite : indexSet.Infinite
  /-- The sequence map xᵏ : I → ℝⁿ -/
  seq : ↥indexSet → EuclideanSpace ℝ (Fin n)