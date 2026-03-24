import Mathlib
open Topology

-- Glove market game: Players {1,2,3}, player 3 owns left glove, players 1,2 own right gloves
-- v(S) = 1 if S contains player 3 and at least one of {1,2}, else 0
-- Shapley value computation: Sh_1 = Sh_2 = 1/6, Sh_3 = 2/3

theorem Example_18AA7 :
    let Sh₁ : ℚ := 1 / 6
    let Sh₂ : ℚ := 1 / 6
    let Sh₃ : ℚ := 2 / 3
    -- Shapley values sum to v(grand coalition) = 1
    Sh₁ + Sh₂ + Sh₃ = 1 ∧
    -- Symmetry: players 1 and 2 get equal shares
    Sh₁ = Sh₂ ∧
    -- Player 3's Shapley value is average of marginal contributions
    -- Orderings: (1,2,3),(1,3,2),(2,1,3),(2,3,1),(3,1,2),(3,2,1)
    -- Marginal contributions of player 3: 1,1,1,1,0,0 → average = 4/6 = 2/3
    Sh₃ = (1 + 1 + 1 + 1 + 0 + 0) / 6 ∧
    -- Players 1 and 2 each get (1 - 2/3)/2 = 1/6
    Sh₁ = (1 - Sh₃) / 2 := by
  norm_num