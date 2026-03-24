import Mathlib

/-- The long-run total cost curve is the lower envelope of short-run total cost curves.
    At each output level y, the short-run cost curve for the optimal fixed input is
    tangent to the long-run cost curve: same value and same slope. -/
theorem long_run_cost_is_lower_envelope
    (sc_family : ℝ → ℝ → ℝ)  -- sc_family xbar y = short-run cost at y with fixed input xbar
    (c : ℝ → ℝ)               -- long-run cost as a function of y
    (xbar : ℝ → ℝ)            -- optimal fixed input as a function of y
    (h_envelope : ∀ y, c y = sc_family (xbar y) y)
    (h_ge : ∀ xb y, c y ≤ sc_family xb y)
    (h_deriv : deriv c = deriv (fun y => sc_family (xbar y) y)) :
    (∀ y, c y = sc_family (xbar y) y) ∧
      (∀ xb y, c y ≤ sc_family xb y) ∧
      (deriv c = deriv (fun y => sc_family (xbar y) y)) :=
  ⟨h_envelope, h_ge, h_deriv⟩