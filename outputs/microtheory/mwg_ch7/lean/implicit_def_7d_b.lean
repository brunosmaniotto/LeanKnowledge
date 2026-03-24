import Mathlib

/-- The normal form (strategic form) representation of a game specifies
the game directly in terms of players, their strategy sets, and
a payoff function mapping strategy profiles to payoffs for each player. -/
structure NormalFormGame (ι : Type*) (S : ι → Type*) where
  /-- The payoff function assigns each player a real-valued payoff
      for every strategy profile (complete assignment of strategies). -/
  payoff : (∀ i, S i) → ι → ℝ