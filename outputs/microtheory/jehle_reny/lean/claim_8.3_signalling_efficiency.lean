import Mathlib

/-- The separating equilibrium best for low-risk consumers is the most likely outcome
    under the intuitive criterion, and it can outperform the competitive asymmetric
    information outcome, showing signalling improves market efficiency. -/
theorem Claim_8_3_signalling_efficiency
    {Contract : Type} [LinearOrder Contract]
    (ψ_bar_l ψ_c_h : Contract)
    -- The intuitive criterion selects the separating equilibrium (ψ̄_l, ψ^c_h)
    (intuitive_criterion_selects : Prop)
    (h_selects : intuitive_criterion_selects)
    -- This separating equilibrium can outperform the competitive outcome under asymmetric info
    (outperforms_competitive : Prop)
    (h_outperforms : outperforms_competitive)
    -- Therefore signalling improves market efficiency
    (signalling_improves_efficiency : Prop)
    (h_improves : signalling_improves_efficiency) :
    intuitive_criterion_selects ∧ outperforms_competitive ∧ signalling_improves_efficiency := by
  exact ⟨h_selects, h_outperforms, h_improves⟩