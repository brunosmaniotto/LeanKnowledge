import Mathlib
open Topology

def BundleGe {n : ℕ} (x₀ x₁ : Fin n → ℝ) : Prop := ∀ i, x₁ i ≤ x₀ i