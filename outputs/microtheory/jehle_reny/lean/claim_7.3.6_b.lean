import Mathlib
open Topology

/--
A node `x` defines a subgame if its information set is a singleton and for any node `y`
that follows `x`, all nodes in `y`'s information set also follow `x`.
This corresponds to Definition 7.16.
-/
structure DefinesSubgame {Node : Type*} (Precedes : Node → Node → Prop) (infoSet : Node → Set Node) (x : Node) : Prop where
  singleton_info_set : infoSet x = {x}
  propagation : ∀ y z : Node, Precedes x y → z ∈ infoSet y → Precedes x z

/--
**Claim 7.3.6(b): If a node x defines a subgame, then every player on every turn knows whether x has been reached.**

We formalize "knowing whether x has been reached" as: for any information set `I`,
either all nodes in `I` are preceded by `x`, or no nodes in `I` are.
The proof relies on `infoSet_is_partition`, a fundamental property that if `y ∈ infoSet x`,
then `infoSet y = infoSet x`.
-/
theorem Claim_7_3_6_b {Node : Type*} {Precedes : Node → Node → Prop} {infoSet : Node → Set Node}
    (infoSet_is_partition : ∀ x y : Node, y ∈ infoSet x → infoSet y = infoSet x)
    (x : Node) (h_subgame : DefinesSubgame Precedes infoSet x) :
    ∀ y : Node, (∀ z ∈ infoSet y, Precedes x z) ∨ (∀ z ∈ infoSet y, ¬ Precedes x z) := by
  -- Let `y` be an arbitrary node, and let `I` be its information set.
  intro y
  let I := infoSet y
  -- We proceed by cases on whether there exists a node in `I` that is preceded by `x`.
  by_cases h_exists : ∃ w ∈ I, Precedes x w
  · -- Case 1: There exists at least one node `w` in `I` such that `Precedes x w`.
    -- In this case, we prove the first part of the disjunction: all nodes in `I` are preceded by `x`.
    left
    -- Let `z` be any node in `I`. We must show `Precedes x z`.
    intro z z_in_I
    -- From `h_exists`, we get a specific `w` in `I` that is preceded by `x`.
    rcases h_exists with ⟨w, w_in_I, hw_precedes⟩
    -- The `propagation` property of `DefinesSubgame` states that if `x` precedes a node `w`,
    -- then `x` also precedes any node in `w`'s information set.
    -- To use this, we show that `z` is in `w`'s information set.
    have z_in_infoSet_w : z ∈ infoSet w := by
      -- Because `w` is in `I = infoSet y`, their information sets are identical by `infoSet_is_partition`.
      -- This gives the equality `infoSet w = infoSet y`, which we use to rewrite the goal.
      rw [infoSet_is_partition y w w_in_I]
      -- The goal is now `z ∈ infoSet y`, which is true by `z_in_I`.
      exact z_in_I
    -- Now we can apply the propagation rule.
    exact h_subgame.propagation w z hw_precedes z_in_infoSet_w
  · -- Case 2: There are no nodes in `I` that are preceded by `x`.
    -- This is the second part of the disjunction, so we prove that.
    right
    -- The hypothesis `h_exists` is `¬(∃ w ∈ I, Precedes x w)`.
    -- This is logically equivalent to `∀ w ∈ I, ¬ Precedes x w`.
    push_neg at h_exists
    exact h_exists