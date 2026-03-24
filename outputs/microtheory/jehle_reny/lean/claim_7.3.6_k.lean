import Mathlib
open Topology

universe u v w

/-- An extensive-form game with perfect recall, capturing the condition that in the same
    information set, the player's action history is the same. -/
structure ExtensiveFormGameWithPerfectRecall (Player : Type u) (Action : Type v) where
  Node : Type w
  info_set : Player → Node → Set Node
  player_actions : Player → Node → List Action
  /-- Axiom: If two nodes are in the same information set for a player, then the player's
      action history up to those nodes is the same. -/
  same_info_set_same_player_actions : ∀ i y w, w ∈ info_set i y → player_actions i y = player_actions i w

namespace ExtensiveFormGameWithPerfectRecall

variable {Player : Type u} {Action : Type v} (g : ExtensiveFormGameWithPerfectRecall Player Action)

/-- Claim 7.3.6(k): Perfect recall implies that any two histories that a player's
    information set does not allow him to distinguish between can differ only in
    the actions taken by other players. In particular, no player ever forgets an
    action that he has taken in the past. -/
theorem Claim_7_3_6_k (i : Player) (y w : g.Node) (h_info : w ∈ g.info_set i y) :
    g.player_actions i y = g.player_actions i w :=
  g.same_info_set_same_player_actions i y w h_info

end ExtensiveFormGameWithPerfectRecall