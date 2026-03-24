import Mathlib

open scoped BigOperators

theorem Claim_5C_c
    {L : ℕ} (hL : 0 < L)
    (p : Fin L → ℝ)
    (gradF : Fin L → ℝ)
    (lam : ℝ)
    (hlam : lam ≠ 0)
    (hFOC : ∀ i : Fin L, p i = lam * gradF i)
    (hgrad : ∀ i : Fin L, gradF i ≠ 0)
    (ℓ k : Fin L) :
    p ℓ / p k = gradF ℓ / gradF k := by
  rw [hFOC ℓ, hFOC k]
  field_simp