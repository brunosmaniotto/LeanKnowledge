import Mathlib
open Topology

/-- A social welfare function aggregates individuals' utilities into a social utility value.
    It reflects the distributional value judgments of the policy maker. -/
structure SocialWelfareFunction (I : Type*) where
  /-- The aggregation function mapping each individual's utility to a social utility value. -/
  W : (I → ℝ) → ℝ