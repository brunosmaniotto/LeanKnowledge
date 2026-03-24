import Mathlib

/-- An extensive-form game with decision nodes, actions, and players. -/
structure ExtensiveFormGame (Node Action Player : Type*) where
  /-- Which player moves at a decision node (`none` if chance or terminal). -/
  player_of : Node → Option Player
  /-- Information set identifier for a node; nodes share an info set iff they map to the same value. -/
  infoSet : Node → ℕ
  /-- `isPredecessor x y` means `x` is a predecessor of `y` in the game tree. -/
  isPredecessor : Node → Node → Prop
  /-- The action taken at node `x` on the path from `x` toward `y`. -/
  actionOnPath : Node → Node → Option Action

/-- Perfect recall: a player never forgets what she once knew, including her own actions.

Condition (i): If two nodes share an information set, neither is a predecessor of the other.
Condition (ii): If decision nodes `x, x'` belong to the same information set for player `i`,
and `x''` is a predecessor of `x` at which player `i` moves with action `a''` on the path to `x`,
then some predecessor of `x'` lies in the same information set as `x''` and takes the same
action `a''` on the path to `x'`. -/
def ExtensiveFormGame.HasPerfectRecall {Node Action Player : Type*}
    (G : ExtensiveFormGame Node Action Player) : Prop :=
  (∀ x x', G.infoSet x = G.infoSet x' → ¬G.isPredecessor x x') ∧
  (∀ x x' x'' : Node, ∀ i : Player,
    G.player_of x = some i →
    G.player_of x' = some i →
    G.infoSet x = G.infoSet x' →
    G.isPredecessor x'' x →
    G.player_of x'' = some i →
    ∃ y, G.isPredecessor y x' ∧
      G.infoSet y = G.infoSet x'' ∧
      G.actionOnPath y x' = G.actionOnPath x'' x)