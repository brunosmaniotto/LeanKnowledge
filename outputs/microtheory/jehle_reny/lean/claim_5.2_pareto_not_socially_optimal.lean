import Mathlib

/-- Walrasian equilibrium allocations are not necessarily 'socially optimal':
    Pareto efficiency does not imply fairness. We exhibit two Pareto-efficient
    allocations (one extremely unequal, one equal) showing that Pareto optimality
    alone cannot distinguish between fair and unfair distributions. -/
theorem claim_5_2_pareto_not_socially_optimal :
    ∃ (alloc_unfair alloc_fair : Fin 2 → ℚ),
      -- Both allocations distribute the same total endowment
      (alloc_unfair 0 + alloc_unfair 1 = 10) ∧
      (alloc_fair 0 + alloc_fair 1 = 10) ∧
      -- Both are Pareto efficient (no reallocation can make one better off
      -- without making the other worse off, under monotone preferences)
      (∀ x : Fin 2 → ℚ, x 0 + x 1 = 10 →
        (x 0 ≥ alloc_unfair 0 ∧ x 1 ≥ alloc_unfair 1) → x = alloc_unfair) ∧
      (∀ x : Fin 2 → ℚ, x 0 + x 1 = 10 →
        (x 0 ≥ alloc_fair 0 ∧ x 1 ≥ alloc_fair 1) → x = alloc_fair) ∧
      -- Yet they differ dramatically in equity
      (alloc_unfair 0 ≠ alloc_unfair 1) ∧
      (alloc_fair 0 = alloc_fair 1) := by
  refine ⟨![9, 1], ![5, 5], ?_, ?_, ?_, ?_, ?_, ?_⟩
  · native_decide
  · native_decide
  · intro x hsum ⟨h0, h1⟩
    funext i; fin_cases i <;> simp_all [Matrix.cons_val_zero, Matrix.cons_val_one] <;> linarith
  · intro x hsum ⟨h0, h1⟩
    funext i; fin_cases i <;> simp_all [Matrix.cons_val_zero, Matrix.cons_val_one] <;> linarith
  · native_decide
  · native_decide