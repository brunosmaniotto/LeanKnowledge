import Mathlib

open Finset BigOperators
open Topology

noncomputable section

variable {n : ℕ} [NeZero n]

def StrictlyIncreasingProd (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, x i ≤ y i) → (∃ i, x i < y i) → f x < f y