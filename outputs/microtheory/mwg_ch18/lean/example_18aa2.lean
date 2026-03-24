import Mathlib
open Topology

/-- A three-player majority voting game in characteristic form.
    Any coalition of two or more players can select among alternatives,
    while singletons get only non-positive payoffs. -/
structure MajorityVotingCharForm where
  /-- The type of alternatives -/
  A : Type*
  /-- The set of available alternatives -/
  alts : Set A
  /-- Nonemptiness of alternatives -/
  alts_nonempty : alts.Nonempty
  /-- Utility functions for each of the three players -/
  u : Fin 3 → A → ℝ
  /-- Utilities are nonnegative -/
  u_nonneg : ∀ i a, a ∈ alts → u i a ≥ 0
  /-- The characteristic form value for the grand coalition I = {1,2,3}:
      V(I) = {(u_1(a), u_2(a), u_3(a)) : a ∈ A} − ℝ^3_+ -/
  V_grand : Set (Fin 3 → ℝ) :=
    {v | ∃ a ∈ alts, ∃ d : Fin 3 → ℝ, (∀ i, d i ≥ 0) ∧ (∀ i, v i = u i a - d i)}
  /-- The characteristic form value for a two-player coalition {i, h}:
      V({i,h}) = {(u_i(a), u_h(a)) : a ∈ A} − ℝ^2_+ -/
  V_pair (i h : Fin 3) (hne : i ≠ h) : Set (Fin 2 → ℝ) :=
    {v | ∃ a ∈ alts, ∃ d : Fin 2 → ℝ, (∀ j, d j ≥ 0) ∧
      v 0 = u i a - d 0 ∧ v 1 = u h a - d 1}
  /-- The characteristic form value for a singleton {i}:
      V({i}) = −ℝ_+ = {x : x ≤ 0} -/
  V_single (i : Fin 3) : Set ℝ :=
    {x | x ≤ 0}