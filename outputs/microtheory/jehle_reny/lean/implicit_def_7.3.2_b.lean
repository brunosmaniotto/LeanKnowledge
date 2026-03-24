import Mathlib
open Topology

/-- The take-away game: two players alternate removing coins from a pile.
    `moves` specifies the allowed numbers of coins to remove per turn.
    The player who faces 0 coins (no legal move) loses. -/
structure TakeAwayGame where
  moves : Finset ℕ
  moves_pos : ∀ m ∈ moves, 0 < m

mutual
/-- A position with `k` coins is a **winning position** if the current player
    can make a legal move that leads to a losing position for the opponent. -/
inductive IsWinningPosition (G : TakeAwayGame) : ℕ → Prop where
  | intro {k : ℕ} (m : ℕ) (hm : m ∈ G.moves) (hle : m ≤ k)
    (h : IsLosingPosition G (k - m)) : IsWinningPosition G k

/-- A position with `k` coins is a **losing position** if every legal move
    leads to a winning position for the opponent — the current player must
    lose under optimal play by both players. -/
inductive IsLosingPosition (G : TakeAwayGame) : ℕ → Prop where
  | intro {k : ℕ}
    (h : ∀ m ∈ G.moves, m ≤ k → IsWinningPosition G (k - m)) :
    IsLosingPosition G k
end