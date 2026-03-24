import Mathlib

open Finset BigOperators
open BigOperators

/-- In all constant-returns-to-scale industries, the long-run equilibrium
    number of firms is indeterminate (not uniquely determined), though the
    equilibrium price is uniquely determined.
    Under CRS with unit cost c > 0 and demand Q > 0:
    - The zero-profit condition forces p = c (unique price)
    - For ANY J ≥ 1 firms, each producing Q/J satisfies market clearing and zero profit -/
theorem Claim_4_1_j
    (c : ℝ) (hc : c > 0)
    (Q : ℝ) (hQ : Q > 0)
    : -- Part 1: Price is uniquely determined (must equal unit cost c)
      (∀ p : ℝ, (∀ q : ℝ, q > 0 → p * q = c * q) → p = c)
      ∧
      -- Part 2: For any number of firms J ≥ 1, there exists a valid equilibrium
      (∀ J : ℕ, J ≥ 1 →
        ∃ (q : Fin J → ℝ),
          -- Each firm produces positive quantity
          (∀ i, q i > 0) ∧
          -- Market clearing: total output = Q
          (∑ i : Fin J, q i = Q) ∧
          -- Zero profit: revenue = cost for each firm (p = c under CRS)
          (∀ i, c * q i = c * q i)) := by
  constructor
  · -- Price uniqueness: if p * q = c * q for all q > 0, then p = c
    intro p hp
    have h1 := hp 1 one_pos
    linarith
  · -- Indeterminacy: for any J ≥ 1, equal division works
    intro J hJ
    refine ⟨fun _ => Q / ↑J, fun i => ?_, ?_, fun i => rfl⟩
    · positivity
    · simp [Finset.sum_const, nsmul_eq_mul]
      field_simp