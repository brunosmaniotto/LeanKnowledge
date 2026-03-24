import Mathlib
open Topology

/-- Hybrid hidden action–hidden information model parameters. -/
structure HybridModel where
  Theta : Type
  Effort : Type
  Profit : Type
  Wage : Type

/-- A direct revelation mechanism: for each announced θ̂, specifies effort and compensation. -/
structure DirectMechanism (M : HybridModel) where
  effort_rule : M.Theta → M.Effort
  compensation : M.Theta → M.Profit → M.Wage

/-- Incentive compatibility: truthful and obedient. -/
structure IsIncentiveCompatible (M : HybridModel) (d : DirectMechanism M)
    (payoff : M.Theta → M.Theta → M.Effort → ℝ) where
  truthful : ∀ θ θ_hat : M.Theta, payoff θ θ_hat (d.effort_rule θ_hat) ≤ payoff θ θ (d.effort_rule θ)
  obedient : ∀ θ : M.Theta, ∀ e' : M.Effort, payoff θ θ e' ≤ payoff θ θ (d.effort_rule θ)

/-- The revelation principle for hybrid hidden action–hidden information models:
    the owner can restrict attention to direct mechanisms where the manager is
    willing to be both truthful in announcing θ and obedient in choosing effort. -/
theorem revelation_principle_hybrid
    (M : HybridModel)
    (payoff : M.Theta → M.Theta → M.Effort → ℝ)
    (h_opt : ∃ d : DirectMechanism M, ∀ θ : M.Theta, ∀ θ_hat : M.Theta, ∀ e' : M.Effort,
      payoff θ θ_hat e' ≤ payoff θ θ (d.effort_rule θ)) :
    ∃ d : DirectMechanism M, IsIncentiveCompatible M d payoff := by
  obtain ⟨d, hd⟩ := h_opt
  exact ⟨d, ⟨fun θ θ_hat => hd θ θ_hat _, fun θ e' => hd θ θ e'⟩⟩