import Mathlib
open Real

-- Define Marginal Revenue and Marginal Cost as noncomputable functions.
-- These definitions are general and can be used in any context where a price/cost function
-- and an equilibrium quantity are differentiable.
noncomputable def MarginalRevenue (D_func : ℝ → ℝ) (x : ℝ) : ℝ :=
  deriv (fun x' => D_func x' * x') x

noncomputable def MarginalCost (AC_func : ℝ → ℝ) (x : ℝ) : ℝ :=
  deriv (fun x' => AC_func x' * x') x

theorem Claim_4_2_3_c
    (q₀ : ℝ) (h_q₀_pos : 0 < q₀)
    (D_curve AC_curve : ℝ → ℝ)
    (h_D_diff : DifferentiableAt ℝ D_curve q₀)
    (h_AC_diff : DifferentiableAt ℝ AC_curve q₀)
    (h_zero_profit : D_curve q₀ = AC_curve q₀) -- Condition (4.22): Price equals average cost (zero profit)
    (h_mr_eq_mc : MarginalRevenue D_curve q₀ = MarginalCost AC_curve q₀) : -- Condition (4.21): Marginal revenue equals marginal cost (profit maximization)
    deriv D_curve q₀ = deriv AC_curve q₀ :=
  by
    -- Expand MarginalRevenue using the product rule for derivatives
    have h_MR_expanded : MarginalRevenue D_curve q₀ = deriv D_curve q₀ * q₀ + D_curve q₀ := by
      calc
        MarginalRevenue D_curve q₀
          = deriv (fun x' => D_curve x' * x') q₀ := by rfl
        _ = deriv (D_curve * id) q₀ := by rfl
        _ = deriv D_curve q₀ * id q₀ + D_curve q₀ * deriv id q₀ :=
          deriv_mul h_D_diff differentiableAt_id
        _ = deriv D_curve q₀ * q₀ + D_curve q₀ * 1 := by simp only [id_eq, deriv_id']
        _ = deriv D_curve q₀ * q₀ + D_curve q₀ := by ring

    -- Expand MarginalCost using the product rule for derivatives
    have h_MC_expanded : MarginalCost AC_curve q₀ = deriv AC_curve q₀ * q₀ + AC_curve q₀ := by
      calc
        MarginalCost AC_curve q₀
          = deriv (fun x' => AC_curve x' * x') q₀ := by rfl
        _ = deriv (AC_curve * id) q₀ := by rfl
        _ = deriv AC_curve q₀ * id q₀ + AC_curve q₀ * deriv id q₀ :=
          deriv_mul h_AC_diff differentiableAt_id
        _ = deriv AC_curve q₀ * q₀ + AC_curve q₀ * 1 := by simp only [id_eq, deriv_id']
        _ = deriv AC_curve q₀ * q₀ + AC_curve q₀ := by ring

    -- Substitute the expanded forms into the MR=MC equilibrium condition
    rw [h_MR_expanded, h_MC_expanded] at h_mr_eq_mc

    -- Use the zero-profit condition (D_curve q₀ = AC_curve q₀) to simplify the equation
    rw [h_zero_profit] at h_mr_eq_mc

    -- The equation now becomes: deriv D_curve q₀ * q₀ + AC_curve q₀ = deriv AC_curve q₀ * q₀ + AC_curve q₀
    -- Simplify by cancelling AC_curve q₀ from both sides
    simp only [add_left_inj] at h_mr_eq_mc

    -- The equation is now: deriv D_curve q₀ * q₀ = deriv AC_curve q₀ * q₀
    -- Since q₀ > 0, it is non-zero, so we can use this to divide by q₀.
    have h_q₀_ne_zero : q₀ ≠ 0 := by linarith [h_q₀_pos]

    -- Use mul_left_inj' to cancel q₀ from both sides, which directly proves the goal.
    exact (mul_left_inj' h_q₀_ne_zero).mp h_mr_eq_mc