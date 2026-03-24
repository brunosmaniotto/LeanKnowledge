import Mathlib
open scoped symmDiff

inductive InsuranceCo | A | B

structure ScreeningEquilibrium (Policy : Type*) where
  Δ_A : Set Policy
  Δ_B : Set Policy
  j_l : InsuranceCo
  ψ_l : Policy
  j_h : InsuranceCo
  ψ_h : Policy

def ScreeningEquilibrium.IsSeparating {Policy : Type*}
    (e : ScreeningEquilibrium Policy) : Prop :=
  e.ψ_l ≠ e.ψ_h