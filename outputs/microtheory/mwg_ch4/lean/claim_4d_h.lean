import Mathlib

open Matrix Finset BigOperators
open BigOperators

theorem Claim_4D_h (L : ℕ) (S : Matrix (Fin L) (Fin L) ℝ)
    (S_individual : Fin L → Matrix (Fin L) (Fin L) ℝ)
    (D : Matrix (Fin L) (Fin L) ℝ)
    (hD : D = ∑ i : Fin L, S_individual i - S)
    (hD_psd : ∀ v : Fin L → ℝ, 0 ≤ v ⬝ᵥ (D.mulVec v)) :
    ∀ v : Fin L → ℝ,
      0 ≤ v ⬝ᵥ ((∑ i : Fin L, S_individual i - S).mulVec v) := by
  intro v
  rw [← hD]
  exact hD_psd v