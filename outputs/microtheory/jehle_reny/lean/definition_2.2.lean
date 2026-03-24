import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Definition 2.2: The set of simple gambles on `n` outcomes.
    A simple gamble is a probability distribution (p_1, ..., p_n) with
    p_i ≥ 0 for all i and ∑ p_i = 1. -/
def SimpleGambles (n : ℕ) : Set (Fin n → ℝ) :=
  {p | (∀ i, 0 ≤ p i) ∧ ∑ i, p i = 1}