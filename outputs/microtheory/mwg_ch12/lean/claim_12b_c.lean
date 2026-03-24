import Mathlib

open BigOperators
open Finset

variable {J : Type} [Fintype J] [DecidableEq J]
variable (u : J → ℝ → ℝ)
variable (c : ℝ → ℝ)

def monopolist_profit_ppd (q : J → ℝ) : ℝ :=
  (∑ i : J, u i (q i)) - (c (∑ i : J, q i))