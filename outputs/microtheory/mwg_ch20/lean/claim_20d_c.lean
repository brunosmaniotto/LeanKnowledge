import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_20D_c
    {n : ℕ}
    (profit : Fin n → ℝ)
    (profit_star : Fin n → ℝ)
    (h_myopic : ∀ i : Fin n, profit i ≤ profit_star i) :
    ∑ i : Fin n, profit i ≤ ∑ i : Fin n, profit_star i := by
  exact Finset.sum_le_sum (fun i _ => h_myopic i)