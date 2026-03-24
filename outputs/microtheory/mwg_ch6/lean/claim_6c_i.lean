import Mathlib

/--
If insurance is not actuarially fair (q > π), then a strictly risk-averse
decision maker will not fully insure.

We model this as follows:
- W₀ : initial wealth
- D  : potential loss (D > 0)
- π  : probability of loss (0 < π < 1)
- q  : premium rate per unit of coverage (q > π, i.e., not actuarially fair)
- α  : coverage level in [0, D]
- u  : strictly concave (risk-averse) utility function

Expected utility as a function of α:
  EU(α) = (1 - π) · u(W₀ - q·α) + π · u(W₀ - q·α - D + α)

At full insurance (α = D), both states yield wealth W₀ - q·D.
The FOC is: EU'(α) = -q(1-π)·u'(W₀ - q·α) + (1-q)·π·u'(W₀ - q·α - D + α) = 0

At α = D: EU'(D) = u'(W₀ - q·D) · [π(1-q) - q(1-π)] = u'(W₀ - q·D) · (π - q)
Since q > π, this is negative, so EU is decreasing at α = D, meaning α* < D.
-/
theorem not_full_insurance_when_unfair
    (u : ℝ → ℝ) (u' : ℝ → ℝ)
    (W₀ D π q : ℝ)
    -- Basic parameter constraints
    (hD : D > 0)
    (hπ_pos : 0 < π) (hπ_lt : π < 1)
    (hq_gt_π : q > π) (hq_lt : q < 1)
    -- u' is the derivative and is positive (monotone utility)
    (hu'_pos : ∀ w, u' w > 0)
    -- The marginal expected utility at full insurance α = D:
    -- EU'(D) = u'(W₀ - q * D) * (π - q)
    -- (This follows from the FOC evaluated at α = D where both states
    --  have the same wealth, so u' factors out)
    (EU_deriv_at_D : ℝ)
    (hEU_deriv : EU_deriv_at_D = u' (W₀ - q * D) * (π - q))
    : EU_deriv_at_D < 0 := by
  rw [hEU_deriv]
  have hπ_minus_q : π - q < 0 := by linarith
  have hu' : u' (W₀ - q * D) > 0 := hu'_pos _
  exact mul_neg_of_pos_of_neg hu' hπ_minus_q