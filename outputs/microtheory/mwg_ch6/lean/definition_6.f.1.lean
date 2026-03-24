import Mathlib
open Topology

/-!
# Definition 6.F.1 — State Uniform Preferences (MWG)

The state preferences (≿₁, ..., ≿_S) on state lotteries are *state uniform*
if ≿_s = ≿_{s'} for every pair of states s and s'.
-/

variable {S : Type*} {X : Type*}

/-- A family of preference relations indexed by states is **state uniform**
if the preference relation is the same in every state. -/
def StateUniform (pref : S → X → X → Prop) : Prop :=
  ∀ s s' : S, pref s = pref s'