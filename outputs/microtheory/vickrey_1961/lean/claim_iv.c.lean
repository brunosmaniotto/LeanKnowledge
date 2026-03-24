import Mathlib

/-- Claim IV.C: In a simultaneous Vickrey auction for m identical items,
    bidders with the top m values win at a uniform price equal to the (m+1)th value.
    The outcome is Pareto-optimal: every winner's value meets or exceeds the clearing price,
    and every loser's value is at most the clearing price. -/
theorem claim_IV_C (n m : ℕ) (hmn : m < n)
    (v : Fin n → ℝ)
    (hv_sorted : ∀ i j : Fin n, i.val ≤ j.val → v j ≤ v i) :
    ∀ (i j : Fin n), i.val < m → m ≤ j.val →
    v j ≤ v ⟨m, hmn⟩ ∧ v ⟨m, hmn⟩ ≤ v i := by
  intro i j hi hj
  exact ⟨hv_sorted ⟨m, hmn⟩ j hj, hv_sorted i ⟨m, hmn⟩ (Nat.le_of_lt hi)⟩