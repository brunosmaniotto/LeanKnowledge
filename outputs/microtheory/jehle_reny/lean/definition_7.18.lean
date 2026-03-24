import Mathlib

/-- An extensive-form game with nodes, actions, players, and information sets. -/
structure ExtensiveFormGame (Node Action Player : Type*) where
  /-- Which player moves at each decision node -/
  playerOf : Node → Player
  /-- Whether x is an ancestor of y in the game tree -/
  isAncestor : Node → Node → Prop
  /-- The first action taken on the path from ancestor x to descendant y -/
  firstActionOnPath : Node → Node → Option Action
  /-- Information set equivalence: nodes x and y are in the same information set -/
  sameInfoSet : Node → Node → Prop

/-- **Perfect recall** (Jehle & Reny, Definition 7.18): An extensive-form game has
    perfect recall if whenever two nodes x and y belong to a single player with
    y = (x, a, a₁, …, aₖ) (i.e., y is reached from x with first action a),
    then every node w in the same information set as y is of the form
    w = (z, a, a'₁, …, a'ₗ) for some z in the same information set as x. -/
def ExtensiveFormGame.HasPerfectRecall {Node Action Player : Type*}
    (G : ExtensiveFormGame Node Action Player) : Prop :=
  ∀ (x y : Node) (a : Action),
    G.playerOf x = G.playerOf y →
    G.isAncestor x y →
    G.firstActionOnPath x y = some a →
    ∀ w : Node, G.sameInfoSet y w →
      ∃ z : Node, G.sameInfoSet x z ∧
        G.isAncestor z w ∧
        G.firstActionOnPath z w = some a