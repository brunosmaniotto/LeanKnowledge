import Mathlib

open Matrix Finset

theorem gross_substitution_price_decrease
    {L : ℕ} [NeZero L]
    (Dpz_inv : Matrix (Fin L) (Fin L) ℝ)
    (Dqz_dq : Fin L → ℝ)
    (hM : ∀ i j, Dpz_inv i j < 0)
    (hv : ∀ j, Dqz_dq j < 0)
    : ∀ i, -(Dpz_inv *ᵥ Dqz_dq) i < 0 := by
  intro i
  simp only [mulVec, dotProduct]
  apply neg_neg_of_pos
  apply Finset.sum_pos
  · intro j _
    exact mul_pos_of_neg_of_neg (hM i j) (hv j)
  · exact Finset.univ_nonempty