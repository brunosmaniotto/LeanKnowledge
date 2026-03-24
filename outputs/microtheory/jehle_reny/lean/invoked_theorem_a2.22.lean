import Mathlib

/-- **Envelope Theorem (MWG Theorem A2.22).**
    V'(t₀) = ∂f/∂t − λ* · ∂g/∂t at the optimum. -/
theorem envelope_theorem
    {V : ℝ → ℝ} {t₀ dV : ℝ}
    {df_dx df_dt dg_dx dg_dt dx_star lam : ℝ}
    (hV : HasDerivAt V dV t₀)
    (h_chain : dV = df_dx * dx_star + df_dt)
    (h_foc : df_dx = lam * dg_dx)
    (h_constraint : dg_dx * dx_star + dg_dt = 0) :
    HasDerivAt V (df_dt - lam * dg_dt) t₀ := by
  have h1 : dg_dx * dx_star = -dg_dt := by linarith
  have h2 : df_dx * dx_star = -lam * dg_dt := by
    rw [h_foc, mul_assoc, h1]; ring
  have heq : dV = df_dt - lam * dg_dt := by linarith
  rwa [← heq]