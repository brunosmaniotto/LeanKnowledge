import Mathlib

open Topology Filter Classical
open BigOperators

-- The equilibrium condition (generalized) for J firms and aggregate output Q
def cournot_equilibrium_condition (p : ℝ → ℝ) (c : ℝ) (J : ℕ) (Q : ℝ) : Prop :=
  deriv p Q * (Q / J) + p Q = c

-- Theorem (Claim_12C_g)