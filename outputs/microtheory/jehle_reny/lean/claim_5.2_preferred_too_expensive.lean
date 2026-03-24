import Mathlib

open BigOperators Finset
open Topology

noncomputable section

/-- Defines the dot product of two vectors in ℝ^n. -/
def dot_product {n : ℕ} (v w : Fin n → ℝ) : ℝ :=
  ∑ j : Fin n, v j * w j