import Mathlib

/-
MWG Example 1.D.1: Three alternatives {a, b, c}, budget sets and choices that
satisfy WARP but no complete, transitive preference relation rationalizes them.

Budget sets and choices:
  B1 = {a, b}    → C(B1) = {a}
  B2 = {b, c}    → C(B2) = {b}
  B3 = {a, c}    → C(B3) = {c}

WARP holds vacuously / by inspection for each pair of budget sets.
But rationalization requires a ≻* b ≻* c ≻* a (cycle), contradicting transitivity.
-/

inductive Alt : Type where
  | a | b | c
  deriving DecidableEq, Fintype

open Alt

-- The three budget sets
def B1 : Finset Alt := {a, b}