import Mathlib

open Matrix Finset

variable {L : ℕ} [NeZero L]

/-- If S(p,w) · p = 0 for nonzero p, then S is singular and its negative
    semidefiniteness cannot be strengthened to negative definiteness. -/
theorem Claim_2F_h
    (S : Matrix (Fin L) (Fin L) ℝ)
    (p : Fin L → ℝ)
    (hp : p ≠ 0)
    (hSp : S.mulVec p = 0)
    (hNSD : ∀ v : Fin L → ℝ, v ⬝ᵥ S.mulVec v ≤ 0) :
    (¬ Function.Injective S.mulVec) ∧
    (¬ ∀ v : Fin L → ℝ, v ≠ 0 → v ⬝ᵥ S.mulVec v < 0) := by
  constructor
  · intro hinj
    apply hp
    have := hinj (show S.mulVec p = S.mulVec 0 by simp [hSp])
    exact this
  · intro hND
    have := hND p hp
    have h2 : p ⬝ᵥ S.mulVec p = 0 := by simp [hSp]
    linarith