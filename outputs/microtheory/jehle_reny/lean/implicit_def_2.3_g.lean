import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure FiniteDemandData (n T : ℕ) where
  p : Fin T → Fin n → ℝ
  x : Fin T → Fin n → ℝ

variable {n T : ℕ}

def DirectRP (D : FiniteDemandData n T) (t s : Fin T) : Prop :=
  ∑ i, D.p t i * D.x s i ≤ ∑ i, D.p t i * D.x t i