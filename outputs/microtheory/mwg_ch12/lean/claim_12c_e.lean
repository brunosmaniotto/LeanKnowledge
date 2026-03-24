import Mathlib

open Real
open Topology

-- Declare variables for the price function and quantities
variable {p : ℝ → ℝ} {q1 q2 : ℝ}

-- Assume the price function `p` is differentiable on ℝ.
-- This ensures that `deriv p` is well-defined.
variable (h_diff_p : Differentiable ℝ p)

/--
In a Cournot duopoly, the derivative term related to price sensitivity in an individual firm's
profit maximization problem (q₁ * p'(Q)) differs from that in joint profit maximization
((q₁ + q₂) * p'(Q)), provided the rival's output (q₂) and the market price sensitivity (p'(Q))
are non-zero.
-/
theorem Claim_12C_e (h_q2_ne_zero : q2 ≠ 0) (h_p_prime_ne_zero : deriv p (q1 + q2) ≠ 0) :
    q1 * (deriv p (q1 + q2)) ≠ (q1 + q2) * (deriv p (q1 + q2)) := by
  -- Assume, for contradiction, that the two derivative terms are equal.
  intro h_eq
  -- Expand the right side of the assumed equality using the distributive property `add_mul`.
  have h_expanded_rhs : (q1 + q2) * (deriv p (q1 + q2)) = q1 * (deriv p (q1 + q2)) + q2 * (deriv p (q1 + q2)) := by
    rw [add_mul]
  -- Substitute the expanded form into our assumption `h_eq`.
  -- This gives: `q1 * (deriv p (q1 + q2)) = q1 * (deriv p (q1 + q2)) + q2 * (deriv p (q1 + q2))`
  have h_temp_eq : q1 * (deriv p (q1 + q2)) = q1 * (deriv p (q1 + q2)) + q2 * (deriv p (q1 + q2)) := by
    rw [h_expanded_rhs] at h_eq
    exact h_eq
  
  -- From `h_temp_eq`, we can use `linarith` to deduce that `q2 * (deriv p (q1 + q2))` must be zero.
  -- (i.e., if A = A + B, then B = 0)
  have h_zero_eq_q2_deriv : q2 * (deriv p (q1 + q2)) = 0 := by
    linarith [h_temp_eq]

  -- We are given two hypotheses: `h_q2_ne_zero : q2 ≠ 0` and `h_p_prime_ne_zero : deriv p (q1 + q2) ≠ 0`.
  -- The product of two non-zero numbers is non-zero, as proven by `mul_ne_zero`.
  have h_product_ne_zero : q2 * (deriv p (q1 + q2)) ≠ 0 :=
    mul_ne_zero h_q2_ne_zero h_p_prime_ne_zero
  
  -- `h_product_ne_zero` states that `q2 * (deriv p (q1 + q2))` is not zero.
  -- `h_zero_eq_q2_deriv` states that `q2 * (deriv p (q1 + q2))` is zero.
  -- These two statements contradict each other. `exact` applies the contradiction.
  exact h_product_ne_zero h_zero_eq_q2_deriv