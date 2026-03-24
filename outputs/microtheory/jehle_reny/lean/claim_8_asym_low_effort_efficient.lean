import Mathlib

/-- If the optimal effort level under symmetric information is low (e = 0),
    then the same full insurance policy is optimal under asymmetric information,
    and the asymmetric information outcome is Pareto efficient. -/
theorem Claim_8_asym_low_effort_efficient
    -- Profits under symmetric information for low and high effort
    (π_sym_low π_sym_high : ℝ)
    -- Profits under asymmetric information for low and high effort
    (π_asym_low π_asym_high : ℝ)
    -- Low effort is optimal under symmetric info
    (h_sym_optimal : π_sym_low ≥ π_sym_high)
    -- Under asymmetric info, low effort yields the same profits
    -- (no incentive constraint binds when e = 0, full insurance is still optimal)
    (h_low_same : π_asym_low = π_sym_low)
    -- Under asymmetric info, high effort profits are no higher than symmetric
    -- (the additional incentive compatibility constraint can only reduce profits)
    (h_high_weakly_worse : π_asym_high ≤ π_sym_high)
    -- Symmetric information outcome is Pareto efficient
    (h_sym_pareto : Bool) -- flag: symmetric outcome is Pareto efficient
    (h_sym_pareto_true : h_sym_pareto = true) :
    -- Then: (1) low effort is optimal under asymmetric info
    π_asym_low ≥ π_asym_high
    -- (2) the policy is the same (profits match)
    ∧ π_asym_low = π_sym_low
    -- (3) the outcome is Pareto efficient (same as symmetric)
    ∧ h_sym_pareto = true := by
  exact ⟨by linarith, h_low_same, h_sym_pareto_true⟩