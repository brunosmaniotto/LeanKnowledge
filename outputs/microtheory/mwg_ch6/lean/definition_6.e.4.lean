import Mathlib
open Topology

def SureThingAxiom {S : Type*} [DecidableEq S] (pref : (S → ℝ) → (S → ℝ) → Prop) : Prop :=
  ∀ (E : Set S) [DecidablePred (· ∈ E)]
    (x x' y y' : S → ℝ),
    (∀ s, s ∉ E → x s = y s) →
    (∀ s, s ∉ E → x' s = y' s) →
    (∀ s, s ∈ E → x s = y s) →
    (∀ s, s ∈ E → x' s = y' s) →
    (pref x x' ↔ pref y y')