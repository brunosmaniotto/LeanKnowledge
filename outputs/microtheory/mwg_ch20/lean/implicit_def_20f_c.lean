import Mathlib

/-- A permanent shock moves the economy to a new utility function ũ(k, k') constant over time,
    changing the entire policy function to a new w̃(·). Both the indifference curves and the
    constraint change in the optimization problem. -/
structure PermanentShock (K : Type*) where
  /-- The new utility function ũ(k, k') that remains constant over time -/
  newUtility : K → K → ℝ
  /-- The new policy function w̃(·) -/
  newPolicy : K → K
  /-- The constraint set changes under the permanent shock -/
  newConstraint : K → Set K
  /-- The policy function is optimal: for each state k, w̃(k) is in the feasible set
      and maximizes the new utility -/
  policy_feasible : ∀ k, newPolicy k ∈ newConstraint k
  policy_optimal : ∀ k k', k' ∈ newConstraint k → newUtility k k' ≤ newUtility k (newPolicy k)