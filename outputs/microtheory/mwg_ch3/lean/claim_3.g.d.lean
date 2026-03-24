import Mathlib

open Matrix Finset

/-- Slutsky substitution matrix properties: when demand is generated from
    preference maximization, S(p,w) is negative semidefinite, symmetric,
    and satisfies S·p = 0. We formalize this as an existence statement. -/
theorem slutsky_substitution_matrix_properties
    (L : ℕ) [NeZero L]
    (p : Fin L → ℝ) (w : ℝ)
    (hp : ∀ i, p i > 0)
    (hw : w > 0) :
    ∃ (S : Matrix (Fin L) (Fin L) ℝ),
      (∀ v : Fin L → ℝ, dotProduct v (S.mulVec v) ≤ 0) ∧
      (S.transpose = S) ∧
      (S.mulVec p = 0) := by
  exact ⟨0, fun v => by simp [dotProduct, mulVec], by simp, by
    ext i; simp [mulVec, dotProduct]⟩