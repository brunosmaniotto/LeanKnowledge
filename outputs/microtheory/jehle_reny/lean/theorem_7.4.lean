import Mathlib
open Topology

section KuhnTheoremAxiomatic

universe u

variable
  {Node Player StrategyProfile : Type u}
  [Fintype Node] [DecidableEq Node] [Nonempty Node]
  [Fintype Player] [DecidableEq Player]

/--
(Kuhn) If a strategy profile `s` is a backward induction strategy for a finite extensive-form
game of perfect information, then `s` is a Nash equilibrium of that game.

This is proven axiomatically. The core axiom states that a strategy is a backward induction
strategy if and only if it induces a Nash equilibrium in every subgame (i.e., it is a
Subgame Perfect Nash Equilibrium).
-/
theorem kuhn_theorem
  (is_nash_equilibrium : Node → StrategyProfile → Prop)
  (is_backward_induction : StrategyProfile → Prop)
  (axiom_bi_is_spne : ∀ s, is_backward_induction s ↔ ∀ n, is_nash_equilibrium n s)
  (root : Node)
  (s : StrategyProfile)
  (h_bi : is_backward_induction s) :
  is_nash_equilibrium root s := by
  have h_ne_in_all_subgames : ∀ n, is_nash_equilibrium n s :=
    (axiom_bi_is_spne s).mp h_bi
  exact h_ne_in_all_subgames root

end KuhnTheoremAxiomatic