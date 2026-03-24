import Mathlib
open Topology

/-- A social welfare function maps profiles of continuous individual utility functions
    to a continuous social utility function. The value f(u)(x) assigned to social state x
    can depend on each individual's entire utility function uᵢ(·), not just uᵢ(x). -/
structure SocialWelfareFunction (X : Type*) [TopologicalSpace X] (N : ℕ) where
  /-- The map from a profile of N continuous utility functions to a social utility function -/
  toFun : (Fin N → C(X, ℝ)) → C(X, ℝ)