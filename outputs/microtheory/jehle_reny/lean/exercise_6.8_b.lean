import Mathlib

open Finset
open Function

variable {N : ℕ} [Fact (N > 1)] -- At least two agents for i and j to be distinct

-- Helper function to create a new utility vector by updating specific indices.
-- u_orig: the original utility vector
-- i, j: the indices to update
-- val_i, val_j: the new values for indices i and j respectively
def update_utilities (u_orig : Fin N → ℝ) (i j : Fin N) (val_i val_j : ℝ) : Fin N → ℝ :=
  update (update u_orig i val_i) j val_j

-- The theorem statement for Exercise 6.8 b