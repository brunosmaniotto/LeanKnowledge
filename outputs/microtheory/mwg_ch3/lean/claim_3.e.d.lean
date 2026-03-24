import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Compensated law of demand (Proposition 3.E.4): for any two price vectors p' and p''
    and Hicksian demand h at utility level u, the inner product
    (p'' - p') · (h(p'', u) - h(p', u)) ≤ 0. -/
theorem compensated_demand_own_price_nonpositive
    {n : ℕ} (ℓ : Fin n)
    (p' p'' : Fin n → ℝ)
    (h' h'' : Fin n → ℝ)
    -- prices differ only in coordinate ℓ
    (hprice : ∀ i, i ≠ ℓ → p'' i = p' i)
    -- compensated law of demand: ∑ (p''_i - p'_i)(h''_i - h'_i) ≤ 0
    (hCLD : ∑ i ∈ Finset.univ, (p'' i - p' i) * (h'' i - h' i) ≤ 0) :
    (p'' ℓ - p' ℓ) * (h'' ℓ - h' ℓ) ≤ 0 := by
  have key : ∑ i ∈ Finset.univ, (p'' i - p' i) * (h'' i - h' i) =
      (p'' ℓ - p' ℓ) * (h'' ℓ - h' ℓ) := by
    apply Finset.sum_eq_single ℓ
    · intro i _ hi
      simp [hprice i hi, sub_self, zero_mul]
    · intro h
      exact absurd (Finset.mem_univ ℓ) h
  linarith [key]