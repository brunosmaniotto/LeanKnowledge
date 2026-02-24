import Mathlib.Data.Real.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Order.Basic
import Mathlib.Algebra.BigOperators.Group.Finset

open BigOperators

/-- A production plan y in Y is efficient if there is no y' in Y such that 
    y' ≥ y and y' ≠ y. -/
def IsEfficient {L : ℕ} (Y : Set (Fin L → ℝ)) (y : Fin L → ℝ) : Prop :=
  y ∈ Y ∧ ∀ y' ∈ Y, (∀ i, y i ≤ y' i) → (∀ i, y i = y' i)

/-- Proposition 5.F.1: If y maximizes profit for some strictly positive price vector p,
    then y is efficient. -/
theorem profit_max_implies_efficient {L : ℕ} (Y : Set (Fin L → ℝ)) (p : Fin L → ℝ) (y : Fin L → ℝ)
    (h_p_pos : ∀ i, 0 < p i)
    (h_y_in_Y : y ∈ Y)
    (h_max : ∀ y' ∈ Y, (∑ i, p i * y' i) ≤ (∑ i, p i * y i)) :
    IsEfficient Y y := sorry
