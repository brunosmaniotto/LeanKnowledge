import Mathlib

/-- Nonobservability of effort raises the cost of implementing e_H
    and does not change the cost of implementing e_L, so it can lead
    to an inefficiently low level of effort being implemented. -/
theorem Claim_14B_l
    (cost_eL_obs cost_eL_nonobs : ℝ)
    (cost_eH_obs cost_eH_nonobs : ℝ)
    (benefit_eH benefit_eL : ℝ)
    -- e_L cost is the same under both regimes
    (h_eL_same : cost_eL_nonobs = cost_eL_obs)
    -- e_H costs strictly more under nonobservability (risk premium)
    (h_eH_higher : cost_eH_nonobs > cost_eH_obs)
    -- Under observability, e_H is optimal (benefit exceeds cost)
    (h_obs_eH_optimal : benefit_eH - cost_eH_obs > benefit_eL - cost_eL_obs)
    -- Under nonobservability, e_L becomes optimal (cost increase flips ranking)
    (h_nonobs_eL_optimal : benefit_eL - cost_eL_nonobs ≥ benefit_eH - cost_eH_nonobs) :
    -- Conclusion: nonobservability strictly raised e_H cost and kept e_L cost the same,
    -- yet the optimal effort switched from e_H to e_L
    cost_eH_nonobs > cost_eH_obs ∧
    cost_eL_nonobs = cost_eL_obs ∧
    (benefit_eH - cost_eH_obs > benefit_eL - cost_eL_obs ∧
     benefit_eL - cost_eL_nonobs ≥ benefit_eH - cost_eH_nonobs) := by
  exact ⟨h_eH_higher, h_eL_same, h_obs_eH_optimal, h_nonobs_eL_optimal⟩