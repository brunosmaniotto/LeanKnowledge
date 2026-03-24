import Mathlib
open Topology

/-- A normal-form game Γ_N = [I, {S_i}, {u_i(·)}] with finite player set I
    and finite pure strategy sets S_i. -/
structure NormalFormGamePure (I : Type*) [Fintype I] [DecidableEq I]
    (S : I → Type*) [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)] where
  /-- Utility for player i given a pure strategy profile. -/
  u : (i : I) → (∀ j, S j) → ℝ

variable {I : Type*} [Fintype I] [DecidableEq I]
  {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]

/-- **Best-response correspondence** (Definition 8.D, MWG).
    For player `i`, given opponents' strategies `s_{-i}`, the set of pure strategies
    `s_i ∈ S_i` such that `u_i(s_i, s_{-i}) ≥ u_i(s'_i, s_{-i})` for all `s'_i ∈ S_i`. -/
def bestResponseCorrespondence (G : NormalFormGamePure I S) (i : I)
    (s : ∀ j, S j) : Set (S i) :=
  {s_i : S i |
    ∀ s'_i : S i,
      G.u i (Function.update s i s'_i) ≤ G.u i (Function.update s i s_i)}