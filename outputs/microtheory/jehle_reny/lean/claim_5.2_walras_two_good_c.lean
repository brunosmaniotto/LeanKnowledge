import Mathlib

open Finset BigOperators
open Topology
open BigOperators

-- Re-defining walras_two_good from "Proven Dependencies" and "Relevant Mathlib lemmas"
-- to ensure it is in scope, as previous attempts failed with "unknown identifier".
theorem walras_two_good
    (p z : Fin 2 → ℝ)
    (hwalras : ∑ i : Fin 2, p i * z i = 0) :
    p 0 * z 0 = -(p 1 * z 1) := by
  rw [Fin.sum_univ_two] at hwalras
  linarith