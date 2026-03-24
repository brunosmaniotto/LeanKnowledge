import Mathlib
open Topology

/-- Strategy-proofness: no individual can strictly gain by misreporting preferences.
    We model this as: for all agents i, for all true preference profiles θ,
    for all possible misreports θ_i', the outcome under truth-telling is
    at least as good as the outcome under misreporting (according to i's true preferences).

    The claim is that this is equivalent to: there is no circumstance where
    some individual strictly gains by misreporting. -/
theorem Claim_6_5_c
    {Agent Outcome Profile : Type*}
    (c : Profile → Outcome)
    (utility : Agent → Profile → Outcome → ℝ)
    -- Strategy-proof: no agent strictly gains by misreporting
    (strategy_proof : Prop)
    (sp_def : strategy_proof ↔
      ∀ (i : Agent) (θ : Profile) (θ' : Profile),
        utility i θ (c θ) ≥ utility i θ (c θ')) :
    -- Forward: strategy-proof ⟹ no one can strictly gain
    (strategy_proof →
      ¬ ∃ (i : Agent) (θ θ' : Profile),
        utility i θ (c θ') > utility i θ (c θ)) ∧
    -- Backward: not strategy-proof ⟹ someone can strictly gain
    (¬ strategy_proof →
      ∃ (i : Agent) (θ θ' : Profile),
        utility i θ (c θ') > utility i θ (c θ)) := by
  constructor
  · intro hsp
    push_neg
    intro i θ θ'
    exact sp_def.mp hsp i θ θ'
  · intro hnsp
    rw [sp_def] at hnsp
    push_neg at hnsp
    obtain ⟨i, θ, θ', hlt⟩ := hnsp
    exact ⟨i, θ, θ', hlt⟩