import Mathlib

/-- Normal form representation of a game with `I` players.
    Γ_N = [I, {S_i}, {u_i(·)}] where each player i has a strategy set
    and a payoff function giving von Neumann–Morgenstern utility levels. -/
structure NormalFormGame (I : Type*) where
  /-- Strategy set for each player -/
  Strategy : I → Type*
  /-- Payoff function for each player, mapping a strategy profile to utility -/
  payoff : I → (∀ i, Strategy i) → ℝ