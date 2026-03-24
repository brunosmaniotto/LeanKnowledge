import Mathlib

/-- Under v(x) = α + β·u(x) with β > 0, the second derivative scales as v″ = β·u″.
    This shows u″ alone cannot measure risk aversion degree, since VNM utility
    is unique only up to positive affine transformations. -/
theorem Claim_2_4_3_c
    (u : ℝ → ℝ) (w α β : ℝ) (hβ : 0 < β)
    (hu : ∀ x, DifferentiableAt ℝ u x)
    (hu' : ∀ x, DifferentiableAt ℝ (deriv u) x) :
    deriv (deriv (fun x => α + β * u x)) w = β * deriv (deriv u) w := by
  have hderiv₁ : deriv (fun x => α + β * u x) = fun x => β * deriv u x := by
    funext x
    have hm : HasDerivAt (fun y => β * u y) (β * deriv u x) x := by
      simpa [zero_mul, zero_add] using (hasDerivAt_const x β).mul (hu x).hasDerivAt
    simpa [zero_add] using ((hasDerivAt_const x α).add hm).deriv
  rw [hderiv₁]
  have h₂ : HasDerivAt (fun y => β * deriv u y) (β * deriv (deriv u) w) w := by
    simpa [zero_mul, zero_add] using (hasDerivAt_const w β).mul (hu' w).hasDerivAt
  exact h₂.deriv