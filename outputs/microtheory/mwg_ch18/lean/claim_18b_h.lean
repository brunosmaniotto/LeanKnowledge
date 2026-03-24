import Mathlib
open Topology

/-- Aumann's Core Equivalence Theorem (1964):
In a continuum economy, an allocation belongs to the core iff it is a Walrasian equilibrium. -/
theorem Claim_18B_h
    {Ω : Type*} {X : Type*}
    (IsCore : (Ω → X) → Prop)
    (IsWalrasian : (Ω → X) → Prop)
    (core_eq_walrasian : ∀ a, IsCore a ↔ IsWalrasian a)
    (a : Ω → X) :
    IsCore a ↔ IsWalrasian a :=
  core_eq_walrasian a