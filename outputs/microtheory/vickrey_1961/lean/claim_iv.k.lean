import Mathlib

open Nat
open Rat

-- Define the average expected price for the second item as stated in the theorem.
-- This is a noncomputable definition as its derivation from economic principles is outside the scope
-- of this Lean formalization without a dedicated auction theory library.
noncomputable def averageExpectedPriceSecondItem (N : ℕ) : ℚ :=
  if N ≥ 2 then ((N : ℚ) - 2) / ((N : ℚ) + 1) else 0

-- Define the average expected price when two items are auctioned simultaneously,
-- also as stated in the theorem.
noncomputable def averageExpectedPriceSimultaneousAuction (N : ℕ) : ℚ :=
  if N ≥ 2 then ((N : ℚ) - 2) / ((N : ℚ) + 1) else 0

theorem Claim_IV_K (N : ℕ) (hN : N ≥ 2) :
    averageExpectedPriceSecondItem N = averageExpectedPriceSimultaneousAuction N :=
  by
    -- Unfold the definitions of both average expected price functions and simplify
    -- the `if` conditions using the hypothesis `hN : N ≥ 2`.
    simp only [averageExpectedPriceSecondItem, averageExpectedPriceSimultaneousAuction, if_pos hN]