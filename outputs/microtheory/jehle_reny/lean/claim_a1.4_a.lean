import Mathlib
open Topology

def IsIncreasing {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, y i ≤ x i) → f y ≤ f x