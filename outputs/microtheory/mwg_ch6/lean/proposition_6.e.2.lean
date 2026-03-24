import Mathlib
open Topology

structure PreferenceRel (S : Type*) [Fintype S] where
  le : (S → ℝ) → (S → ℝ) → Prop
  refl : ∀ x, le x x
  trans : ∀ x y z, le x y → le y z → le x z

def SureThingAxiom {S : Type*} [Fintype S] [DecidableEq S]
    (P : PreferenceRel S) : Prop :=
  ∀ (s : S) (x y : S → ℝ) (a : ℝ),
    P.le x y → ∀ c : ℝ, P.le (Function.update x s c) (Function.update y s c)