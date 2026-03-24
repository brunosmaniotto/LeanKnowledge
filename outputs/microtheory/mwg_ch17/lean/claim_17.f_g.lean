import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The gross substitute property is additive across excess demand functions:
    if each individual excess demand function satisfies gross substitutes
    (i.e., for k ≠ ℓ, z_k^i(p') > z_k^i(p)), then the aggregate
    Σ_i z_k^i(p') > Σ_i z_k^i(p). -/
theorem gross_substitute_additive
    {I : Type*} [Fintype I] [Nonempty I]
    (z z' : I → ℝ)
    (h : ∀ i, z' i > z i) :
    ∑ i : I, z' i > ∑ i : I, z i := by
  exact Finset.sum_lt_sum (fun i _ => le_of_lt (h i)) ⟨Classical.arbitrary I, Finset.mem_univ _, h _⟩