import Mathlib

open BigOperators Finset
open Topology

/-- Players with von Neumann–Morgenstern expected utility preferences.
    Each player i ∈ I has a Bernoulli utility function uᵢ : C → ℝ over outcomes.
    When facing a lottery over outcomes, player i evaluates it by expected utility:
    Uᵢ(L) = ∑_c L(c) · uᵢ(c), and chooses to maximise this quantity. -/
structure VNMPreferences (I : Type*) (C : Type*) [Fintype C] where
  /-- Bernoulli utility function for each player over outcomes -/
  bernoulli : I → C → ℝ

/-- The expected utility of a lottery for player i under vNM preferences.
    Given a lottery L : C → ℝ (probability weights on outcomes),
    player i's expected utility is ∑_c L(c) · uᵢ(c). -/
noncomputable def G.expectedUtility
    {I C : Type*} [Fintype C]
    (pref : VNMPreferences I C) (i : I) (lottery : C → ℝ) : ℝ :=
  ∑ c : C, lottery c * pref.bernoulli i c