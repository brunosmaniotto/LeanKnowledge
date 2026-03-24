import Mathlib

open BigOperators Finset

theorem Claim_8_FOC_redundancy_asym
    {L : ℕ}
    (prob : Fin (L + 1) → ℝ)
    (c : Fin (L + 1) → ℝ)
    (μ : ℝ)
    (hprob_sum : ∑ l : Fin (L + 1), prob l = 1)
    (hFOC_individual : ∀ l : Fin (L + 1), c l = μ)
    : ∑ l : Fin (L + 1), prob l * c l = μ := by
  simp only [hFOC_individual]
  rw [← Finset.sum_mul]
  simp [hprob_sum]