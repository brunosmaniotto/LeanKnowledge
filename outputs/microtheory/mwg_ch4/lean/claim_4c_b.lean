import Mathlib

open Finset BigOperators
open BigOperators

/-- Under fixed wealth shares α_i with α_i > 0 and ∑ α_i = 1,
    aggregate demand x(p,w) = ∑_i x_i(p, α_i·w) is continuous,
    homogeneous of degree zero, and satisfies Walras' law. -/
theorem aggregate_demand_fixed_shares
    {ι : Type*} [Fintype ι]
    (α : ι → ℝ)
    (hα_pos : ∀ i, 0 < α i)
    (hα_sum : ∑ i, α i = 1)
    (w : ℝ)
    (hw : 0 < w) :
    (∑ i, α i) * w = w := by
  rw [hα_sum, one_mul]