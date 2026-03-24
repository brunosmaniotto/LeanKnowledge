import Mathlib
open Topology

/-- An allocation in an exchange economy with `I` consumers and `n` goods.
    Each consumer `i` receives a bundle `xᵢ ∈ ℝⁿ₊` (the non-negative orthant). -/
structure Allocation (I n : ℕ) where
  /-- The consumption bundle assigned to each consumer for each good. -/
  bundle : Fin I → Fin n → ℝ
  /-- Every component of every consumer's bundle is non-negative (ℝⁿ₊). -/
  nonneg : ∀ i j, 0 ≤ bundle i j