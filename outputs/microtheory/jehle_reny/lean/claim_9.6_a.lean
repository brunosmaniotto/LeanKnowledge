import Mathlib
open Finset
open BigOperators

noncomputable section

inductive SocialState
  | S
  | B
  | D

open SocialState
open Topology
set_option linter.unusedVariables false

variable (N : ℕ) (hN : N ≥ 2) (t : Fin N → ℕ) (ht : ∀ i, 1 ≤ t i)

def valuation (i : Fin N) (s : SocialState) : ℝ :=
  match s with
  | S => (t i : ℝ) + 5
  | B => 2 * (t i : ℝ)
  | D => if (i : ℕ) = 0 then 10 else 0