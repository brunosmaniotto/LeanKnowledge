import Mathlib
open Topology

/-- The three alternatives in the Vetoers example (Example 21.D.2). -/
inductive Alt3 : Type
  | x | y | z
  deriving DecidableEq, Fintype

/-- Vetoers social preference rule for two agents and three alternatives {x, y, z}.
    Social preferences coincide with agent 1's preferences, except agent 2 can veto
    x being socially preferred to y: if agent 2 weakly prefers y to x, then y is
    socially at least as good as x.

    Formally, v is socially at least as good as w if either:
    (1) v ≿₁ w (agent 1 weakly prefers v to w), or
    (2) v = y, w = x, and y ≿₂ x (agent 2 weakly prefers y to x). -/
def vetoersSocialPref
    (pref1 : Alt3 → Alt3 → Prop)
    (pref2 : Alt3 → Alt3 → Prop)
    (v w : Alt3) : Prop :=
  pref1 v w ∨ (v = Alt3.y ∧ w = Alt3.x ∧ pref2 Alt3.y Alt3.x)