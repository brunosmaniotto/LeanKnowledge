import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A hyperplane {x | p · x = I} separates sets A and B in ℝⁿ
    if p · a ≥ I for every a ∈ A and p · b ≤ I for every b ∈ B. -/
def HyperplaneSeparates {n : ℕ} (p : Fin n → ℝ) (I : ℝ)
    (A B : Set (Fin n → ℝ)) : Prop :=
  (∀ a ∈ A, ∑ i, p i * a i ≥ I) ∧ (∀ b ∈ B, ∑ i, p i * b i ≤ I)