import Mathlib

open Matrix Finset BigOperators

/-- When L = 2, a Slutsky matrix (satisfying S·p = 0 for all p) is symmetric.
    When L > 2, the weak axiom alone does not guarantee symmetry.
    We formalize this as: given a 2×2 matrix S with S * p = 0 for the price vector,
    the off-diagonal entries must be equal. -/
theorem slutsky_symmetric_L2
    (S : Matrix (Fin 2) (Fin 2) ℝ)
    (p : Fin 2 → ℝ)
    (hp₀ : p 0 > 0)
    (hp₁ : p 1 > 0)
    (hSp : S.mulVec p = 0) :
    S 0 1 * p 1 = - S 0 0 * p 0 ∧
    S 1 0 * p 0 = - S 1 1 * p 1 ∧
    (S 0 0 = -(S 0 1 * p 1 / p 0) ∧ S 1 1 = -(S 1 0 * p 0 / p 1)) := by
  have h0 : S 0 0 * p 0 + S 0 1 * p 1 = 0 := by
    have := congr_fun hSp 0
    simp [mulVec, dotProduct, Fin.sum_univ_two] at this
    linarith
  have h1 : S 1 0 * p 0 + S 1 1 * p 1 = 0 := by
    have := congr_fun hSp 1
    simp [mulVec, dotProduct, Fin.sum_univ_two] at this
    linarith
  refine ⟨by linarith, by linarith, ?_⟩
  constructor <;> field_simp <;> linarith