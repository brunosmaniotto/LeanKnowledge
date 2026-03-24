import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If each firm maximizes profit at prices p, the aggregate production is efficient. -/
theorem aggregate_profit_maximization_is_efficient
    {n J : ℕ} (p : Fin n → ℝ) (Y : Fin J → Set (Fin n → ℝ))
    (y_star : Fin J → Fin n → ℝ)
    (hfeas : ∀ j, y_star j ∈ Y j)
    (hmax : ∀ j, ∀ y' ∈ Y j, ∑ i, p i * y' i ≤ ∑ i, p i * y_star j i)
    (y_agg : Fin J → Fin n → ℝ)
    (hagg_feas : ∀ j, y_agg j ∈ Y j) :
    ∑ j, ∑ i, p i * y_agg j i ≤ ∑ j, ∑ i, p i * y_star j i := by
  apply Finset.sum_le_sum
  intro j _
  exact hmax j (y_agg j) (hagg_feas j)