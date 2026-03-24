import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Each individual's externality is non-negative because x̃_i(t_{-i}) maximizes
    the sum of utilities of individuals j ≠ i. -/
theorem Claim_9_5_4_a
    {I X : Type*} [Fintype I] [DecidableEq I]
    (v : I → X → ℝ)
    (i : I)
    (x_tilde : X)  -- x̃_i(t_{-i}): maximizer of Σ_{j≠i} v_j
    (x_hat : X)    -- x̂(t): social choice
    (h_max : ∀ x : X, ∑ j ∈ univ.filter (· ≠ i), v j x ≤
                       ∑ j ∈ univ.filter (· ≠ i), v j x_tilde) :
    0 ≤ ∑ j ∈ univ.filter (· ≠ i), v j x_tilde -
        ∑ j ∈ univ.filter (· ≠ i), v j x_hat := by
  linarith [h_max x_hat]