import Mathlib

open Finset BigOperators
open BigOperators
set_option linter.unusedVariables false

theorem Claim_VCG_surplus {N : ℕ} {T : Type} [Fintype T] (c_VCG : T → Fin N → ℝ) (q : T → ℝ)
    (hq : ∀ t, 0 ≤ q t) (h_cost_nonneg : ∀ (t : T) (i : Fin N), 0 ≤ c_VCG t i) :
    0 ≤ ∑ t ∈ Finset.univ, q t * (∑ i ∈ Finset.univ, c_VCG t i) := by
  apply Finset.sum_nonneg
  intro t ht
  have inner_nonneg : 0 ≤ ∑ i ∈ Finset.univ, c_VCG t i := by
    apply Finset.sum_nonneg
    intro i hi
    exact h_cost_nonneg t i
  exact mul_nonneg (hq t) inner_nonneg