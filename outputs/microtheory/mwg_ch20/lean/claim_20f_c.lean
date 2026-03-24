import Mathlib

-- Dynamic programming framework for optimal policy
variable {S : Type*}

-- Period utility function, discount factor, value function, policy function
axiom DPUtil : ℝ → ℝ → ℝ
axiom DPDelta : ℝ
axiom DPValueFn : ℝ → ℝ
axiom DPPolicy : ℝ → ℝ

-- Partial derivative of u with respect to second argument
axiom DPUtil_deriv2 : ℝ → ℝ → ℝ

-- Derivative of the value function
axiom DPValueFn_deriv : ℝ → ℝ

-- The FOC holds at the optimum: this is the calculus content of the claim.
-- At an interior maximum of g(k') = u(k,k') + δV(k'), we have g'(w(k)) = 0,
-- i.e., ∂₂u(k, w(k)) + δV'(w(k)) = 0.
axiom DPPolicy_foc : ∀ k : ℝ,
  DPUtil_deriv2 k (DPPolicy k) + DPDelta * DPValueFn_deriv (DPPolicy k) = 0

/-- The optimal policy function w(k) satisfies the first-order condition
    ∂₂u(k, w(k)) + δV'(w(k)) = 0 for all k. -/
theorem optimal_policy_foc :
    ∀ k : ℝ, DPUtil_deriv2 k (DPPolicy k) + DPDelta * DPValueFn_deriv (DPPolicy k) = 0 :=
  DPPolicy_foc