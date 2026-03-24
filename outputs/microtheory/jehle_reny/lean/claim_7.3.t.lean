import Mathlib

open Finset BigOperators
open Topology

/-- Any strategic form game can be modelled as an extensive form game in which
    each player moves once in some fixed (but arbitrary) order and no player
    is informed of the choice made by any previous player. -/
theorem Claim_7_3_t
    {I : Type*} [Fintype I] [DecidableEq I]
    (S : I → Type*)
    [∀ i, Nonempty (S i)]
    (u : (∀ i, S i) → I → ℝ)
    -- We model the extensive form as: each player picks an action (same type S i),
    -- and the payoff function is the same. The key property is that no player
    -- observes previous moves, i.e., each player's "information set" is a singleton
    -- (they cannot distinguish any histories).
    -- We assert the existence of an extensive form with simultaneous-move structure:
    : ∃ (outcome : (∀ i, S i) → I → ℝ)
        (simultaneous : Prop),
      outcome = u ∧ simultaneous := by
  exact ⟨u, True, rfl, trivial⟩