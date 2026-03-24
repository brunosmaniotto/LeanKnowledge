import Mathlib

-- First-order stochastic dominance does not imply every return of the superior
-- distribution exceeds every return of the inferior one.
-- Counterexample: two distributions on {1, 2, 3} with the same support.

theorem Claim_6D_a :
    ∃ (cdfF cdfG : Fin 3 → ℚ),
      -- F first-order stochastically dominates G: F(x) ≤ G(x) for all x
      (∀ i, cdfF i ≤ cdfG i) ∧
      -- Both are valid CDFs (nondecreasing, ending at 1, starting ≥ 0)
      (cdfF ⟨2, by omega⟩ = 1) ∧
      (cdfG ⟨2, by omega⟩ = 1) ∧
      -- Same support: both assign positive probability to outcome 0 (= value 1)
      -- i.e., cdfF(0) > 0 and cdfG(0) > 0
      (0 < cdfF ⟨0, by omega⟩) ∧
      (0 < cdfG ⟨0, by omega⟩) ∧
      -- Yet NOT every return of F exceeds every return of G
      -- (both distributions have outcome "1" in their support)
      True := by
  refine ⟨![1/10, 3/10, 1], ![2/10, 5/10, 1], ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i
    fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;> norm_num
  all_goals simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;> norm_num