import Mathlib

open Set Filter

/-- In general, the profit-maximizing production set y(p) may be empty (no maximizer exists),
    which occurs when the supremum of profit is +∞ (unbounded). -/
theorem Claim_5C_a :
    ∃ (Y : Set ℝ) (p : ℝ), (∀ M : ℝ, ∃ y ∈ Y, p * y > M) ∧
      ∀ y ∈ Y, ∃ y' ∈ Y, p * y' > p * y := by
  refine ⟨Set.univ, 1, ?_, ?_⟩
  · intro M
    exact ⟨M + 1, Set.mem_univ _, by linarith⟩
  · intro y _
    exact ⟨y + 1, Set.mem_univ _, by ring_nf; linarith⟩