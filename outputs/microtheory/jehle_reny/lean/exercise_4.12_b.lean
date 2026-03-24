import Mathlib

noncomputable section

/-- In a Bertrand duopoly with fixed costs F > 0 and identical marginal cost c,
    a break-even equilibrium price p* exists where (p* - c) · D(p*) / 2 = F.
    At this price, each firm earns zero profit when splitting the market,
    so neither wants to deviate (undercutting yields negative profit, exiting yields 0). -/
theorem exercise_4_12_b
    (F : ℝ) (hF : F > 0)
    (c : ℝ)
    (D : ℝ → ℝ)
    (hD_cont : Continuous D)
    -- Market viability: some price yields enough duopoly profit to cover fixed costs
    (h_viable : ∃ p, c ≤ p ∧ (p - c) * D p / 2 ≥ F) :
    -- Break-even equilibrium price exists
    ∃ p_star, c ≤ p_star ∧ (p_star - c) * D p_star / 2 = F := by
  obtain ⟨ph, hle, hge⟩ := h_viable
  -- π(p) = (p - c) · D(p) / 2 is continuous on [c, ph]
  have hcont : ContinuousOn (fun p => (p - c) * D p / 2) (Set.Icc c ph) :=
    (((continuous_id.sub continuous_const).mul hD_cont).div_const 2).continuousOn
  -- π(c) = 0 ≤ F
  have hlo : (fun p => (p - c) * D p / 2) c ≤ (fun _ => F) c := by simp; linarith
  -- F ≤ π(ph) by viability, so by IVT ∃ p* ∈ [c, ph] with π(p*) = F
  obtain ⟨p_star, ⟨hps_lb, _⟩, hps_eq⟩ :=
    isPreconnected_Icc.intermediate_value₂
      (Set.left_mem_Icc.mpr hle) (Set.right_mem_Icc.mpr hle)
      hcont continuousOn_const hlo hge
  exact ⟨p_star, hps_lb, hps_eq⟩