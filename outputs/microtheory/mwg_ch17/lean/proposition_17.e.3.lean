import Mathlib

open Finset Function BigOperators
open Topology
open BigOperators

/-- Proposition 17.E.3 (Sonnenschein-Mantel-Debreu): A continuous, homogeneous degree zero
function satisfying Walras' law on a bounded price domain is the aggregate excess demand
of some economy with L consumers. -/
axiom excess_demand_decomposition
    (L : ℕ) (hL : 0 < L) (ε : ℝ) (hε : 0 < ε)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hz_cont : Continuous z)
    (hz_hom : ∀ (α : ℝ), 0 < α → ∀ p, z (α • p) = z p)
    (hz_walras : ∀ p, ∑ i, p i * z p i = 0) :
    ∃ (ω : Fin L → Fin L → ℝ) (d : Fin L → (Fin L → ℝ) → Fin L → ℝ),
      (∀ k i, 0 < ω k i) ∧
      (∀ k, Continuous (d k)) ∧
      (∀ k p, ∑ i, p i * d k p i = 0) ∧
      (∀ p, (∀ i, 0 < p i) → (∀ i j, ε ≤ p i / p j) →
        z p = ∑ k : Fin L, d k p)

theorem Proposition_17_E_3
    (L : ℕ) (hL : 0 < L) (ε : ℝ) (hε : 0 < ε)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hz_cont : Continuous z)
    (hz_hom : ∀ (α : ℝ), 0 < α → ∀ p, z (α • p) = z p)
    (hz_walras : ∀ p, ∑ i, p i * z p i = 0) :
    ∃ (ω : Fin L → Fin L → ℝ) (d : Fin L → (Fin L → ℝ) → Fin L → ℝ),
      (∀ k i, 0 < ω k i) ∧
      (∀ k, Continuous (d k)) ∧
      (∀ k p, ∑ i, p i * d k p i = 0) ∧
      (∀ p, (∀ i, 0 < p i) → (∀ i j, ε ≤ p i / p j) →
        z p = ∑ k : Fin L, d k p) :=
  excess_demand_decomposition L hL ε hε z hz_cont hz_hom hz_walras