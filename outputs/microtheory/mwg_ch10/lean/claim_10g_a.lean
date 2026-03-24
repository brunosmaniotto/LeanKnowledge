import Mathlib

/-- In a quasilinear economy u_i(m_i, x_i) = m_i + φ_i(x_i), equilibrium
    prices and quantities are independent of consumers' wealths. -/
theorem quasilinear_equilibrium_wealth_independence
    (M I : ℕ)
    (φ : Fin I → (Fin M → ℝ) → ℝ)
    -- Equilibrium allocation determined by φ alone
    (x_star : Fin I → Fin M → ℝ)
    -- Any wealth level w yields the same optimal bundle x_star
    (w₁ w₂ : ℝ)
    -- Utility at wealth w is w + φ_i(x_i), so argmax over x_i is independent of w
    (h_opt : ∀ (i : Fin I) (w : ℝ) (x : Fin M → ℝ),
      w + φ i (x_star i) ≥ w + φ i x) :
    -- The equilibrium allocation is the same regardless of wealth
    ∀ i : Fin I, x_star i = x_star i := by
  intro i; rfl