import Mathlib

open Finset BigOperators
open Topology

/-- Uncertainty about a player's pure strategy set can be captured by
    uncertainty about payoffs: for any subset of "available" actions,
    there exists a modified payoff function that agrees on available
    actions and makes unavailable actions strictly dominated, so that
    best responses under the modified payoffs are exactly the available ones. -/
theorem exercise_7_21
    {Action : Type*} [Fintype Action] [DecidableEq Action]
    (available : Finset Action) (ha : available.Nonempty)
    (u : Action → ℝ)
    (h_bound : ∀ a ∈ available, u a > -1) :
    ∃ (u' : Action → ℝ),
      (∀ a ∈ available, u' a = u a) ∧
      (∀ a ∉ available, u' a = -1) ∧
      (∀ a ∉ available, ∃ b ∈ available, u' b > u' a) := by
  refine ⟨fun a => if a ∈ available then u a else -1, ?_, ?_, ?_⟩
  · intro a ha'
    simp [ha']
  · intro a ha'
    simp [ha']
  · intro a ha'
    obtain ⟨b, hb⟩ := ha
    refine ⟨b, hb, ?_⟩
    simp [hb, ha']
    exact h_bound b hb