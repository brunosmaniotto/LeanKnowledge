import Mathlib

/-- The indirect utility function and expenditure function are inverses:
    v(p, ·) = e⁻¹(p, ·) and e(p, ·) = v⁻¹(p, ·). -/
theorem Claim_1_4_3_e
    {L : Type*} [Fintype L]
    (v : (L → ℝ) → ℝ → ℝ)
    (e : (L → ℝ) → ℝ → ℝ)
    (p : L → ℝ)
    -- Equation (1.18): e(p, v(p, w)) = w
    (h_ev : ∀ w, e p (v p w) = w)
    -- Equation (1.19): v(p, e(p, u)) = u
    (h_ve : ∀ u, v p (e p u) = u) :
    Function.LeftInverse (v p) (e p) ∧ Function.RightInverse (v p) (e p) := by
  exact ⟨h_ve, h_ev⟩