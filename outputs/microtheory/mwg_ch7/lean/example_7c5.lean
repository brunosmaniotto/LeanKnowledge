import Mathlib

/-- Players in Matching Pennies. -/
inductive MP.Player where | P1 | P2

/-- Actions in Matching Pennies. -/
inductive MPAction where | Heads | Tails

/-- Extensive-form game tree with nature (chance) moves. -/
inductive ExtensiveTreeN where
  | terminal (payoff : ℚ × ℚ)
  | decision (player : MP.Player) (heads tails : ExtensiveTreeN)
  | nature (prob : ℚ) (left right : ExtensiveTreeN)

/-- Matching Pennies Version D: a fair coin flip determines who moves first.
    Nature moves at the root with probability 1/2 for each branch.
    Left branch: Player 1 moves first (Version B with P1 first).
    Right branch: Player 2 moves first (Version B with P2 first). -/
def matchingPenniesVersionD : ExtensiveTreeN :=
  .nature (1/2)
    (.decision .P1
      (.decision .P2 (.terminal (1, -1)) (.terminal (-1, 1)))
      (.decision .P2 (.terminal (-1, 1)) (.terminal (1, -1))))
    (.decision .P2
      (.decision .P1 (.terminal (1, -1)) (.terminal (-1, 1)))
      (.decision .P1 (.terminal (-1, 1)) (.terminal (1, -1))))