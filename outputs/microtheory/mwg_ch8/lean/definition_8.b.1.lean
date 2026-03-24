import Mathlib
open Topology

/-- A game in normal form with finitely many players. -/
structure NormalFormGame (I : Type*) where
  /-- Strategy set for each player -/
  S : I → Type*
  /-- Utility function for each player, taking a strategy profile -/
  u : (i : I) → ((j : I) → S j) → ℝ

/-- A strategy `si` is strictly dominant for player `i` if it yields strictly
    higher utility than any other strategy for `i`, regardless of what the
    other players do. -/
def IsStrictlyDominant {I : Type*} [DecidableEq I] (Γ : NormalFormGame I)
    (i : I) (si : Γ.S i) : Prop :=
  ∀ si' : Γ.S i, si' ≠ si →
    ∀ s_neg_i : (j : I) → j ≠ i → Γ.S j,
      Γ.u i (fun j => if h : j = i then h ▸ si else s_neg_i j h) >
      Γ.u i (fun j => if h : j = i then h ▸ si' else s_neg_i j h)