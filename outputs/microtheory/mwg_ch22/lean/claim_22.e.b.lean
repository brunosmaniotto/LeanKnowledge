import Mathlib

open BigOperators Finset Real
open Topology

/-- The Nash bargaining solution satisfies IUU: the ordering by ∑ ln uᵢ
    is invariant under positive rescaling of each coordinate. -/
theorem nash_bargaining_IUU {n : ℕ} (u u' β : Fin n → ℝ)
    (hu : ∀ i, 0 < u i) (hu' : ∀ i, 0 < u' i) (hβ : ∀ i, 0 < β i) :
    ∑ i, Real.log (u i) > ∑ i, Real.log (u' i) ↔
    ∑ i, Real.log (β i * u i) > ∑ i, Real.log (β i * u' i) := by
  have h1 : ∀ i, Real.log (β i * u i) = Real.log (β i) + Real.log (u i) :=
    fun i => Real.log_mul (ne_of_gt (hβ i)) (ne_of_gt (hu i))
  have h2 : ∀ i, Real.log (β i * u' i) = Real.log (β i) + Real.log (u' i) :=
    fun i => Real.log_mul (ne_of_gt (hβ i)) (ne_of_gt (hu' i))
  simp_rw [h1, h2, sum_add_distrib]
  constructor <;> intro h <;> linarith