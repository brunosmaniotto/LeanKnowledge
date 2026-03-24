import Mathlib

open Set Filter
open scoped Topology

variable {U : Set ℂ} {z0 : ℂ} {f : ℂ → ℂ}

def condition1 (U : Set ℂ) (z0 : ℂ) (f : ℂ → ℂ) : Prop :=
  ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧ ∀ z ∈ U \ {z0}, g z = f z