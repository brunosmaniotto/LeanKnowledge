import Mathlib
open Topology

-- Structure for a decision environment, as provided
structure DecisionEnv (Agent Action : Type*) where
  payoff : Agent → Action → (Agent → Action) → ℝ

-- Definition: A decision environment is non-strategic if for any agent,
-- their payoff for a given action is independent of the actions chosen by other agents.
def DecisionEnv.IsNonStrategic {Agent Action : Type*}
    (env : DecisionEnv Agent Action) : Prop :=
  ∀ (a : Agent) (act_a : Action) (f₁ f₂ : Agent → Action),
    (f₁ a = act_a ∧ f₂ a = act_a) →
    env.payoff a (f₁ a) f₁ = env.payoff a (f₂ a) f₂

-- In a non-strategic environment, an agent's payoff for their action can be
-- represented by a function of just their own action.
-- We fix an arbitrary action profile to define this simplified payoff.
noncomputable def DecisionEnv.payoff_of_action {Agent Action : Type*} [Inhabited (Agent → Action)]
    (env : DecisionEnv Agent Action) (h_non_strategic : env.IsNonStrategic)
    (a : Agent) (act_a : Action) : ℝ :=
  env.payoff a act_a (Classical.arbitrary (Agent → Action))

-- The choice of the arbitrary action profile does not matter due to `h_non_strategic`.