import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- An economy defining a game in characteristic form. -/
structure CharacteristicFormGame (I : Type*) [Fintype I] (L : ℕ) where
  /-- Utility function for each consumer -/
  utility : I → (Fin L → ℝ) → ℝ
  /-- Endowment for each consumer (strictly positive) -/
  endowment : I → (Fin L → ℝ)
  /-- Publicly available production set (convex, constant returns) -/
  Y : Set (Fin L → ℝ)
  /-- Y is convex -/
  Y_convex : Convex ℝ Y
  /-- Y has constant returns to scale (is a cone) -/
  Y_cone : ∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → (t • y) ∈ Y
  /-- Endowments are strictly positive -/
  endowment_pos : ∀ i : I, ∀ l : Fin L, 0 < endowment i l
  /-- Utility functions are continuous -/
  utility_continuous : ∀ i : I, Continuous (utility i)
  /-- Utility functions are concave -/
  utility_concave : ∀ i : I, ConcaveOn ℝ Set.univ (utility i)

/-- The characteristic function V(S) for a coalition S. V(S) consists of utility vectors
    achievable by coalition S using their combined endowments and the technology Y,
    minus the positive cone ℝ^S_+. -/
noncomputable def CharacteristicFormGame.V {I : Type*} [Fintype I] [DecidableEq I] {L : ℕ}
    (G : CharacteristicFormGame I L) (S : Finset I) : Set (I → ℝ) :=
  {u : I → ℝ | ∃ (x : I → (Fin L → ℝ)) (y : Fin L → ℝ) (d : I → ℝ),
    y ∈ G.Y ∧
    (∀ l : Fin L, ∑ i ∈ S, x i l = ∑ i ∈ S, G.endowment i l + y l) ∧
    (∀ i ∈ S, d i ≥ 0) ∧
    (∀ i ∈ S, u i = G.utility i (x i) - d i)}