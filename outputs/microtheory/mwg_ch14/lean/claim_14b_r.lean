import Mathlib

/-- Linear compensation schemes w(π) = a + b * π are robust: the marginal incentive
    (slope b) is constant and independent of the profit realization π.
    This formalizes the Holmström-Milgrom (1987) insight that linear schemes
    provide incentives regardless of early realizations. -/
theorem linear_compensation_robustness
    (a b : ℝ) :
    ∀ π₁ π₂ : ℝ,
      let w := fun π => a + b * π
      (deriv w π₁) = (deriv w π₂) := by
  intro π₁ π₂
  have h1 : (fun π => a + b * π) = (fun π => a + b * π) := rfl
  have hd : ∀ x, HasDerivAt (fun π => a + b * π) b x := by
    intro x
    have := (hasDerivAt_const x a).add ((hasDerivAt_const x b).mul (hasDerivAt_id x))
    simp [mul_one] at this
    exact this
  simp only []
  rw [(hd π₁).deriv, (hd π₂).deriv]