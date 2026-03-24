import Mathlib

open BigOperators

/-- Assumption 5.2(1) (0 ∈ Y) guarantees firm profits π(p) = sup{p · y : y ∈ Y} ≥ 0,
    since the firm can always choose y = 0, yielding profit p · 0 = 0. -/
theorem Claim_5_3_a
    {L : ℕ} (Y : Set (Fin L → ℝ)) (p : Fin L → ℝ)
    (h_zero : (0 : Fin L → ℝ) ∈ Y)
    (h_bdd : BddAbove ((fun y => ∑ l : Fin L, p l * y l) '' Y)) :
    0 ≤ sSup ((fun y => ∑ l : Fin L, p l * y l) '' Y) := by
  apply le_csSup h_bdd
  exact ⟨0, h_zero, by simp⟩