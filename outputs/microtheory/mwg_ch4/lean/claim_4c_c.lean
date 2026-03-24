import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

noncomputable def dot (a b : Fin n → ℝ) : ℝ := ∑ i, a i * b i

variable (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ))

def WeakAxiom : Prop :=
  ∀ (p p' : Fin n → ℝ) (w w' : ℝ),
    dot p' (x p w) ≤ w' → x p' w' ≠ x p w → dot p (x p' w') > w