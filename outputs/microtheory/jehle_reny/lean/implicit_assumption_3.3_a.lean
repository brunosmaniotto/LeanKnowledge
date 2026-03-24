import Mathlib
open Topology

/-- A perfectly competitive firm's input price environment.
    The firm faces fixed input prices `w = (w₁, …, wₙ) ≥ 0` that are
    unaffected by its input choices (price-taking assumption). -/
structure CompetitiveInputPrices (n : ℕ) where
  /-- Fixed input price vector -/
  w : Fin n → ℝ
  /-- All input prices are non-negative: wᵢ ≥ 0 -/
  nonneg : ∀ i, 0 ≤ w i