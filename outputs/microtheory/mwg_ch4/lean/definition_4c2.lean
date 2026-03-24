import Mathlib
open Topology
open BigOperators

/-- A demand function satisfies the Uncompensated Law of Demand (ULD) if for any
    price vectors p, p' and wealth w, the dot product (p' - p) · (x(p', w) - x(p, w)) ≤ 0,
    with strict inequality whenever x(p', w) ≠ x(p, w). -/
structure UncompensatedLawOfDemand (n : ℕ) where
  /-- The demand function maps a price vector and wealth to a demand vector. -/
  demand : (Fin n → ℝ) → ℝ → (Fin n → ℝ)
  /-- Weak ULD: price and demand changes have nonpositive dot product. -/
  weak_uld : ∀ (p p' : Fin n → ℝ) (w : ℝ),
    ∑ i : Fin n, (p' i - p i) * (demand p' w i - demand p w i) ≤ 0
  /-- Strict ULD: the inequality is strict when demand actually changes. -/
  strict_uld : ∀ (p p' : Fin n → ℝ) (w : ℝ),
    demand p' w ≠ demand p w →
    ∑ i : Fin n, (p' i - p i) * (demand p' w i - demand p w i) < 0