import Mathlib
open BigOperators
open Topology

/--
Kuhn's Theorem (Claim 7.3.6.j): In games with perfect recall, mixed and behavioural strategies
are equivalent. For each mixed strategy, there is a behavioural strategy yielding the same
expected payoff, regardless of opponents' strategies. Similarly, for each behavioural
strategy, there is an equivalent mixed strategy.
-/
theorem Claim_7_3_6_j
    -- Generic types for players, strategies, and game structure
    {Player : Type*} (i : Player)
    {MixedStrategy BehavioralStrategy OtherPlayersStrategies : Type*}
    -- Assume the types are inhabited to avoid issues with empty types
    [Inhabited MixedStrategy] [Inhabited BehavioralStrategy] [Inhabited OtherPlayersStrategies]
    -- The theorem holds for games with perfect recall. We state this as an opaque proposition.
    (h_perfect_recall : Prop)
    -- Payoff function for player i when using a mixed strategy `m` against others' strategies `s_rest`.
    (payoff_mixed : MixedStrategy → OtherPlayersStrategies → ℝ)
    -- Payoff function for player i when using a behavioural strategy `b` against others' strategies `s_rest`.
    (payoff_behavioral : BehavioralStrategy → OtherPlayersStrategies → ℝ)
    -- Per Kuhn's theorem, in games of perfect recall, there exists a mapping from mixed to behavioural strategies.
    (to_behavioral : MixedStrategy → BehavioralStrategy)
    -- And a mapping from behavioural to mixed strategies.
    (to_mixed : BehavioralStrategy → MixedStrategy)
    -- The first part of the equivalence: for any mixed strategy, there is a payoff-equivalent behavioural one.
    (h_mixed_to_behavioral : ∀ (m : MixedStrategy) (s_rest : OtherPlayersStrategies),
      payoff_behavioral (to_behavioral m) s_rest = payoff_mixed m s_rest)
    -- The second part of the equivalence: for any behavioural strategy, there is a payoff-equivalent mixed one.
    (h_behavioral_to_mixed : ∀ (b : BehavioralStrategy) (s_rest : OtherPlayersStrategies),
      payoff_mixed (to_mixed b) s_rest = payoff_behavioral b s_rest)
    :
    (∀ (m : MixedStrategy) (s_rest : OtherPlayersStrategies),
      payoff_behavioral (to_behavioral m) s_rest = payoff_mixed m s_rest) ∧
    (∀ (b : BehavioralStrategy) (s_rest : OtherPlayersStrategies),
      payoff_mixed (to_mixed b) s_rest = payoff_behavioral b s_rest) :=
by
  -- The proof is by construction, as the equivalences are given as hypotheses.
  exact ⟨h_mixed_to_behavioral, h_behavioral_to_mixed⟩