import Mathlib

open Finset BigOperators
open Topology
open BigOperators

def SatisfiesULD {n : ℕ} (x : (Fin n → ℝ) → (Fin n → ℝ)) : Prop :=
  ∀ p p' : Fin n → ℝ, ∑ i : Fin n, (p' i - p i) * (x p' i - x p i) ≤ 0