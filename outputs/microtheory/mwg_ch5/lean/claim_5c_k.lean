import Mathlib

open Real

theorem Claim_5C_k
    {L : ℕ} (hL : 0 < L)
    (w : Fin L → ℝ) (hw : ∀ i, 0 < w i)
    (Df : Fin L → ℝ)
    (hDf : ∀ i, 0 < Df i)
    (mu : ℝ) (hmu_pos : 0 < mu)
    (hFOC : ∀ i, Df i = mu * w i)
    (l k : Fin L) :
    Df l / Df k = w l / w k := by
  have hDfk : Df k ≠ 0 := ne_of_gt (hDf k)
  have hwk : w k ≠ 0 := ne_of_gt (hw k)
  rw [hFOC l, hFOC k]
  field_simp