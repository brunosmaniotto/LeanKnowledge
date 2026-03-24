import Mathlib

open BigOperators
open Finset

variable {L I J : ℕ}

-- The variables for prices, allocations, endowments, outputs, and profit shares
variable (p : Finset.range L → ℝ)
variable (x : Finset.range I → Finset.range L → ℝ)
variable (ω : Finset.range I → Finset.range L → ℝ)
variable (y : Finset.range J → Finset.range L → ℝ)
variable (θ : Finset.range I → Finset.range J → ℝ)

-- The specific good 'k' for which we want to prove market clearing
variable {k : Finset.range L}

-- Helper definitions for aggregated quantities of a specific good 'l'
def total_x_of_good (l : Finset.range L) : ℝ := ∑ i : Finset.range I, x i l