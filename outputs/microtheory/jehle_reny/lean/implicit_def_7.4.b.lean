import Mathlib
open Topology

/-- A two-person zero-sum game. Player 1 chooses from `X`, player 2 from `Y`.
    Player 1's payoff is `u(x, y)` and player 2's payoff is `−u(x, y)`. -/
structure ZeroSumGame (X Y : Type*) where
  /-- Player 1's payoff function. Player 2's payoff is the negation. -/
  payoff₁ : X → Y → ℝ

namespace ZeroSumGame

/-- Player 2's payoff in a zero-sum game is the negation of player 1's payoff. -/
noncomputable def payoff₂ {X Y : Type*} (G : ZeroSumGame X Y) (x : X) (y : Y) : ℝ :=
  -G.payoff₁ x y

end ZeroSumGame