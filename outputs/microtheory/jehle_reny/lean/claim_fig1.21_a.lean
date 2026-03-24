import Mathlib

open Finset BigOperators
open BigOperators

variable {L : ℕ}

/-- Hicksian demands are homogeneous of degree zero in prices:
    scaling prices by t > 0 does not change the expenditure minimizer. -/
theorem hicksian_demand_hod0
    (p : Fin L → ℝ) (t : ℝ) (ht : 0 < t)
    (S : Set (Fin L → ℝ))
    (x_star : Fin L → ℝ)
    (hmin : ∀ y ∈ S, ∑ i : Fin L, p i * x_star i ≤ ∑ i : Fin L, p i * y i) :
    ∀ y ∈ S, ∑ i : Fin L, (t * p i) * x_star i ≤ ∑ i : Fin L, (t * p i) * y i := by
  intro y hy
  simp_rw [mul_assoc, ← Finset.mul_sum]
  exact mul_le_mul_of_nonneg_left (hmin y hy) ht.le