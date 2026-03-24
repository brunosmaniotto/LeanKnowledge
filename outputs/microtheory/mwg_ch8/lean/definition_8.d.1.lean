import Mathlib
open Topology

structure NashEquilibrium
    (I : Type*) [DecidableEq I] [Fintype I]
    (S : I → Type*) [∀ i, DecidableEq (S i)] [∀ i, Fintype (S i)]
    (u : (∀ i, S i) → I → ℝ) where
  profile : ∀ i, S i
  is_equilibrium : ∀ (i : I) (s'_i : S i),
    u profile i ≥ u (Function.update profile i s'_i) i