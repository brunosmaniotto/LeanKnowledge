import Mathlib

structure DecisionEnv (Agent Action : Type*) where
  payoff : Agent → Action → (Agent → Action) → ℝ

def DecisionEnv.IsNonStrategic {Agent Action : Type*}
    (env : DecisionEnv Agent Action) (i : Agent) : Prop :=
  ∀ (a : Action) (σ₁ σ₂ : Agent → Action), env.payoff i a σ₁ = env.payoff i a σ₂