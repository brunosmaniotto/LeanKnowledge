import Mathlib

/-- Envelope Theorem (unconstrained, N=S=1, M=0):
    If x(q) maximizes f(x, q) for each q (so ∂f/∂x = 0 at x(q)),
    and v(q) = f(x(q), q), then dv/dq = ∂f/∂q evaluated at (x(q), q). -/
theorem envelope_theorem_unconstrained
    (f : ℝ → ℝ → ℝ)
    (x : ℝ → ℝ)
    (v : ℝ → ℝ)
    (q₀ : ℝ)
    (hv : ∀ q, v q = f (x q) q)
    -- partial derivative of f w.r.t. first arg at (x(q₀), q₀) is zero (FOC)
    (hfoc : deriv (fun x' => f x' q₀) (x q₀) = 0)
    -- v is differentiable at q₀ via chain rule
    (hv_deriv : HasDerivAt v
      (deriv (fun x' => f x' q₀) (x q₀) * deriv x q₀ +
       deriv (fun q => f (x q₀) q) q₀) q₀) :
    deriv v q₀ = deriv (fun q => f (x q₀) q) q₀ := by
  have := hv_deriv.deriv
  rw [hfoc] at this
  simp at this
  exact this