import Mathlib

open Finset BigOperators Matrix
open Topology
open BigOperators

/-- A system of asset prices q ∈ ℝ^K is arbitrage-free if there is no portfolio z
    such that q · z ≤ 0, R z ≥ 0 (in every state), and R z ≠ 0 (strictly positive
    in some state). -/
def IsArbitrageFree {S K : ℕ} (q : Fin K → ℝ) (R : Matrix (Fin S) (Fin K) ℝ) : Prop :=
  ¬ ∃ z : Fin K → ℝ,
    (∑ k, q k * z k) ≤ 0 ∧
    (∀ s : Fin S, 0 ≤ ∑ k, R s k * z k) ∧
    (∃ s : Fin S, 0 < ∑ k, R s k * z k)