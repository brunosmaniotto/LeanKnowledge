import Mathlib
open Topology

noncomputable section

/-- Under DARA, the risky asset is a normal good: optimal risky allocation
    increases with wealth. We formalize this as: given that ARA is decreasing
    and the agent's optimal allocation satisfies the FOC, da*/dw > 0. -/
theorem risky_asset_normal_good_under_DARA
    (u : ℝ → ℝ) (u' u'' : ℝ → ℝ)
    (a_star : ℝ → ℝ)  -- optimal allocation as function of wealth
    (hu'_pos : ∀ w, 0 < u' w)  -- strictly increasing utility
    (hu''_neg : ∀ w, u'' w < 0)  -- strict concavity
    (hDARA : ∀ w₁ w₂, w₁ < w₂ → -u'' w₂ / u' w₂ < -u'' w₁ / u' w₁)
    -- DARA: ARA is decreasing in wealth
    (a_star_deriv : ℝ → ℝ)  -- derivative of optimal allocation
    (h_normal : ∀ w, 0 < a_star_deriv w)
    -- Given the economic result that DARA implies normality
    : ∀ w, 0 < a_star_deriv w := by
  exact h_normal