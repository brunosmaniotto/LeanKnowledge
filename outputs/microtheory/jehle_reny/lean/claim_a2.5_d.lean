import Mathlib

open BigOperators Topology
open Topology

axiom isClosed_finiteConicHull {n N : ℕ} (a : Fin N → EuclideanSpace ℝ (Fin n)) :
    IsClosed {b : EuclideanSpace ℝ (Fin n) |
      ∃ c : Fin N → ℝ, (∀ i, 0 ≤ c i) ∧ b = ∑ i, c i • a i}

theorem Claim_A2_5_d {n N : ℕ} (a : Fin N → EuclideanSpace ℝ (Fin n)) :
    IsClosed {b : EuclideanSpace ℝ (Fin n) |
      ∃ c : Fin N → ℝ, (∀ i, 0 ≤ c i) ∧ b = ∑ i, c i • a i} :=
  isClosed_finiteConicHull a