import Mathlib
open Filter Topology BigOperators
open Topology
open BigOperators

/-- Agent normal form: each information set is an independent "agent." -/
structure AgentNormalForm where
  Agent : Type*
  Action : Agent → Type*
  owner : Agent → ℕ
  payoff : (∀ a, Action a) → ℕ → ℝ
  [finAgent : Fintype Agent]
  [decAgent : DecidableEq Agent]
  [finAction : ∀ a, Fintype (Action a)]

attribute [instance] AgentNormalForm.finAgent AgentNormalForm.decAgent AgentNormalForm.finAction

/-- A strategy profile σ is extensive-form trembling-hand perfect if it is
    a limit of totally mixed strategy profiles in the agent normal form,
    where each approximating profile is a best response. -/
def IsExtensiveFormTHP (A : AgentNormalForm)
    (σ : ∀ a, A.Action a → ℝ) : Prop :=
  ∃ seq : ℕ → (∀ a, A.Action a → ℝ),
    (∀ n a (act : A.Action a), seq n a act > 0) ∧
    Filter.Tendsto seq Filter.atTop (nhds σ) ∧
    ∀ n a (act : A.Action a) (act' : A.Action a),
      ∑ f : ∀ b, A.Action b,
        (∏ b, seq n b (f b)) *
        A.payoff (Function.update f a act) (A.owner a) ≥
      ∑ f : ∀ b, A.Action b,
        (∏ b, seq n b (f b)) *
        A.payoff (Function.update f a act') (A.owner a)