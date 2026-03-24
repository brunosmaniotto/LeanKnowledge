import Mathlib

open Finset BigOperators
open BigOperators

variable {L : ℕ}

abbrev Bundle (L : ℕ) := Fin L → ℝ

noncomputable def expenditure (p x : Bundle L) : ℝ :=
  ∑ i : Fin L, p i * x i

def hicksianDemand (p : Bundle L) (u : Bundle L → ℝ) (u_bar : ℝ) : Set (Bundle L) :=
  { x | (∀ i, 0 ≤ x i) ∧ u x ≥ u_bar ∧
    ∀ y, (∀ i, 0 ≤ y i) → u y ≥ u_bar → expenditure p x ≤ expenditure p y }