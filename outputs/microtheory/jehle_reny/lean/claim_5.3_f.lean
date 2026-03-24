import Mathlib
open Finset BigOperators Topology
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

def lkDot (p y : Fin n → ℝ) : ℝ := ∑ i, p i * y i

axiom berge_continuous_selection
    {n : ℕ} {Y : Set (Fin n → ℝ)} (hK : IsCompact Y) (hne : Y.Nonempty)
    (sel : (Fin n → ℝ) → Fin n → ℝ)
    (hsel : ∀ p, sel p ∈ Y ∧ lkDot p (sel p) = ⨆ y ∈ Y, lkDot p y) :
    Continuous sel