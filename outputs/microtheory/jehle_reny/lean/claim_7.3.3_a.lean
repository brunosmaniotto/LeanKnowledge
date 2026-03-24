import Mathlib
open Topology

/-!
# Claim 7.3.3(a): Action Choice in a Pure Strategy

This file formalizes the principle that a player's action choice in a pure
strategy depends only on their current information set, not on the specific
history (node) that led to it.

The formalization is abstract, focusing on the core components: nodes, actions,
and information sets, to show that the claim is a direct consequence of defining
a strategy as a function on information sets.
-/

-- To model this abstractly, we first define what a pure strategy is in general.
-- It is a function from a set of "information" to a set of "actions".
/-- A pure strategy is a function from information sets to actions. -/
abbrev PureStrategy (InfoSet Action : Type*) := InfoSet → Action

-- Now, we consider the context of a game.
section GameContext

-- We assume a game has nodes, actions, and information sets.
variable (Node Action InfoSet : Type*)

-- We assume there is a way to determine the information set for any given node.
variable (info_set_of_node : Node → InfoSet)

/--
**Claim 7.3.3(a)**: A player's choice of action in a pure strategy can depend
only on which information set he is currently faced with.

If two nodes `n₁` and `n₂` belong to the same information set, then any
pure strategy `s` must prescribe the same action. This is because `s` is a
function of the information set, and its inputs (`info_set_of_node n₁` and
`info_set_of_node n₂`) are equal by hypothesis.
-/
theorem Claim_7_3_3_a
    (s : PureStrategy InfoSet Action)
    (n₁ n₂ : Node)
    (h_same_info_set : info_set_of_node n₁ = info_set_of_node n₂) :
    s (info_set_of_node n₁) = s (info_set_of_node n₂) := by
  -- The proof is by rewriting with the equality hypothesis.
  -- If the inputs to a function are equal, the outputs must be equal.
  rw [h_same_info_set]

end GameContext