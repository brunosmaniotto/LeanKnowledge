import Mathlib
open Topology

theorem strictly_dominant_is_unique_best_response
    {Strategy : Type} {OpponentAction : Type}
    [DecidableEq Strategy]
    (payoff : Strategy → OpponentAction → ℝ)
    (s : Strategy)
    (h_dominant : ∀ (t : Strategy), t ≠ s → ∀ (a : OpponentAction), payoff s a > payoff t a) :
    ∀ (a : OpponentAction), ∀ (t : Strategy), payoff s a ≥ payoff t a := by
  intro a t
  by_cases h : t = s
  · subst h; exact le_refl _
  · exact le_of_lt (h_dominant t h a)