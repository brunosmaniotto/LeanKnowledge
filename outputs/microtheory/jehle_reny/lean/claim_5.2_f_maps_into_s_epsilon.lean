import Mathlib
open BigOperators Finset Set Topology
open Topology

set_option maxHeartbeats 400000

noncomputable section

variable {n : ℕ}

def S_ε (ε : ℝ) : Set (Fin n → ℝ) :=
  {p | (∑ k, p k) = 1 ∧ ∀ k, p k ≥ ε / (1 + 2 * (n : ℝ))}