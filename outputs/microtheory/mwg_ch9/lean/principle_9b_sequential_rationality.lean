import Mathlib
open Topology

/-- An extensive form game tree with finite players. -/
structure ExtensiveFormGame where
  numPlayers : ℕ
  Node : Type
  decisionNodes : Finset Node
  toMove : Node → Fin numPlayers
  numActions : Node → ℕ
  next : (v : Node) → Fin (numActions v) → Node
  payoff : Fin numPlayers → Node → ℝ

/-- A strategy for player i assigns an action to each decision node. -/
def ExtensiveFormGame.Strategy (G : ExtensiveFormGame) (_ : Fin G.numPlayers) :=
  (v : G.Node) → Fin (G.numActions v)

/-- The outcome node reached from a given node under a strategy profile,
    computed with a fuel bound to ensure termination. -/
noncomputable def ExtensiveFormGame.outcome
    (G : ExtensiveFormGame)
    [DecidableEq G.Node]
    (strategies : (i : Fin G.numPlayers) → G.Strategy i)
    (v : G.Node)
    (fuel : ℕ) : G.Node :=
  match fuel with
  | 0 => v
  | fuel' + 1 =>
    if v ∈ G.decisionNodes then
      G.outcome strategies (G.next v (strategies (G.toMove v) v)) fuel'
    else v

/-- Construct a deviated strategy profile where player i plays action `a` at node `v`
    but follows `σ_i` everywhere else, while all other players keep their strategies. -/
noncomputable def ExtensiveFormGame.deviate
    (G : ExtensiveFormGame)
    [DecidableEq G.Node]
    (σ : (j : Fin G.numPlayers) → G.Strategy j)
    (i : Fin G.numPlayers)
    (v : G.Node)
    (a : Fin (G.numActions v)) :
    (j : Fin G.numPlayers) → G.Strategy j :=
  Function.update σ i (fun w =>
    if h : w = v then h ▸ a else σ i w)

/-- **Sequential Rationality** (MWG Principle 9.B):
A player's strategy satisfies sequential rationality if it specifies optimal actions
at every point in the game tree. At every decision node where player `i` moves,
no unilateral deviation to a different action yields a strictly higher payoff.
This rules out noncredible threats (e.g., "fight if firm E plays in" in the predation game). -/
structure SequentiallyRational
    (G : ExtensiveFormGame)
    [DecidableEq G.Node]
    (i : Fin G.numPlayers)
    (σ : (j : Fin G.numPlayers) → G.Strategy j)
    (depth : ℕ) : Prop where
  optimal_at_every_node :
    ∀ (v : G.Node),
      v ∈ G.decisionNodes →
      G.toMove v = i →
      ∀ (a : Fin (G.numActions v)),
        G.payoff i (G.outcome (G.deviate σ i v a) v depth) ≤
        G.payoff i (G.outcome σ v depth)