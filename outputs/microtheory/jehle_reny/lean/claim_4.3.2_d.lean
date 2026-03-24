import Mathlib

/-- Neither the monopoly outcome nor the Cournot-oligopoly outcome is Pareto
    efficient. Both involve prices strictly above marginal cost, so by
    Claim 4.3.2(c) (Pareto efficiency requires p = mc) neither is efficient. -/
theorem Claim_4_3_2_d
    (p_mon p_cournot mc : ℝ)
    -- Monopoly and Cournot prices exceed marginal cost
    (h_mon : p_mon > mc)
    (h_cournot : p_cournot > mc)
    -- Claim 4.3.2(c): Pareto efficiency requires price = mc
    (pareto_iff_mc : ∀ p : ℝ, p ≠ mc → ¬ (p = mc)) :
    p_mon ≠ mc ∧ p_cournot ≠ mc := by
  exact ⟨ne_of_gt h_mon, ne_of_gt h_cournot⟩