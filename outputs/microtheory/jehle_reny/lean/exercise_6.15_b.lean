import Mathlib

open Finset BigOperators
open Set
open Topology

-- Assuming n is a natural number and Fin n → ℝ is the domain for y
variable {n : ℕ} [NeZero n] -- NeZero n for division by n in mean_y

-- Definition of e, the vector of 1's
def e_vec : Fin n → ℝ := fun _ => 1

-- Definition of mean_y, the mean of the distribution y