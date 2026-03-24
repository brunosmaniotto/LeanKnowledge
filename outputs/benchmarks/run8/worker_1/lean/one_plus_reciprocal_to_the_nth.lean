import Mathlib

open Finset
open BigOperators

noncomputable section

def seq : ℕ → ℝ := fun n => (1 + 1 / ((n : ℝ) + 1)) ^ (n + 1)