import Mathlib
open Finset
open Classical
open Topology
set_option linter.unusedVariables false

inductive GameTree (Player : Type) (Action : Type) where
  | leaf (payoff : Player → ℝ)
  | node (player : Player) (actions : Finset Action) (h_nonempty : actions.Nonempty) (next : Action → GameTree Player Action)

noncomputable def backwardInductionPayoff {Player Action : Type} : GameTree Player Action → (Player → ℝ)
  | .leaf payoff => payoff
  | .node player actions h_nonempty next =>
      let payoffs (a : Action) := backwardInductionPayoff (next a)
      let payoff_values : Finset ℝ := Finset.image (fun a => payoffs a player) actions
      have h_payoff_nonempty : payoff_values.Nonempty := by
        rcases h_nonempty with ⟨a, ha⟩
        exact ⟨payoffs a player, mem_image.mpr ⟨a, ha, rfl⟩⟩
      let best_value := payoff_values.max' h_payoff_nonempty
      have h_exists_best_action : ∃ a ∈ actions, payoffs a player = best_value := by
        have h_mem : best_value ∈ payoff_values := Finset.max'_mem _ _
        rcases mem_image.mp h_mem with ⟨a, ha, h⟩
        exact ⟨a, ha, h⟩
      let best_action := Classical.choose h_exists_best_action
      payoffs best_action

theorem Claim_7_3_5_a (Player Action : Type) (t : GameTree Player Action) :
    ∃ pay : Player → ℝ, pay = backwardInductionPayoff t :=
  ⟨backwardInductionPayoff t, rfl⟩