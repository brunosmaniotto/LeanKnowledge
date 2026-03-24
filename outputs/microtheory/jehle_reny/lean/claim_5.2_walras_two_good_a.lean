import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem walras_two_good
    (p z : Fin 2 → ℝ)
    (hwalras : ∑ i, p i * z i = 0) :
    p 0 * z 0 = -(p 1 * z 1) := by
  have h := hwalras
  simp [Fin.sum_univ_two] at h
  linarith