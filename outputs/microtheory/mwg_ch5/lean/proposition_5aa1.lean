import Mathlib

open Matrix BigOperators Finset

variable {L : ℕ} [NeZero L]

theorem Proposition_5AA1
    (A : Matrix (Fin L) (Fin L) ℝ)
    (hInv : Invertible (1 - A))
    (hNonneg : ∀ i j, 0 ≤ (⅟ (1 - A) : Matrix (Fin L) (Fin L) ℝ) i j)
    (c : Fin L → ℝ)
    (hc : ∀ i, 0 ≤ c i) :
    ∃ α : Fin L → ℝ, (∀ i, 0 ≤ α i) ∧ (1 - A) *ᵥ α = c := by
  refine ⟨(⅟ (1 - A)) *ᵥ c, ?_, ?_⟩
  · intro i
    simp only [mulVec, dotProduct]
    apply Finset.sum_nonneg
    intro j _
    exact mul_nonneg (hNonneg i j) (hc j)
  · rw [mulVec_mulVec, mul_invOf_self, one_mulVec]