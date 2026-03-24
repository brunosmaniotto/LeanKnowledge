import Mathlib
open Topology

/-- Players in a two-player game. -/
inductive MP.Player where
  | P1 | P2
deriving DecidableEq, Repr

/-- Extensive-form game tree for two-player games with binary choices (Heads/Tails). -/
inductive ExtensiveTree where
  /-- A terminal node with payoffs (player 1, player 2). -/
  | terminal (payoff : Int × Int) : ExtensiveTree
  /-- A decision node: the given player chooses Heads (left) or Tails (right). -/
  | decision (player : MP.Player) (heads tails : ExtensiveTree) : ExtensiveTree

/-- **Matching Pennies Version B.** Sequential version of Matching Pennies:
    Player 1 puts her penny down first, then Player 2 observes and chooses.
    The game tree has Player 1's decision node at the root with two branches,
    each leading to a Player 2 decision node with two branches, yielding four
    terminal nodes. Payoffs are (+1, −1) when pennies match (Player 1 wins)
    and (−1, +1) when they differ (Player 2 wins). -/
def Example_7C1_MatchingPenniesB : ExtensiveTree :=
  -- Player 1 chooses Heads or Tails
  .decision .P1
    -- Player 1 chose Heads; Player 2 now chooses
    (.decision .P2
      (.terminal (1, -1))     -- P2 Heads: match → P1 wins
      (.terminal (-1, 1)))    -- P2 Tails: mismatch → P2 wins
    -- Player 1 chose Tails; Player 2 now chooses
    (.decision .P2
      (.terminal (-1, 1))     -- P2 Heads: mismatch → P2 wins
      (.terminal (1, -1)))    -- P2 Tails: match → P1 wins