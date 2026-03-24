import Mathlib
open Topology

def VectorGe {n : ℕ} (x y : Fin n → ℝ) : Prop := ∀ i, y i ≤ x i