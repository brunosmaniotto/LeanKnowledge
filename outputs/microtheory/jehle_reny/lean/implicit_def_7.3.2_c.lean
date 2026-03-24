import Mathlib

/-- A finite extensive-form game tree for N players with binary branching.
    Terminal nodes carry a payoff vector; decision nodes specify the
    moving player and two successor subtrees. -/
inductive GameTree (N : ℕ) where
  | terminal : (Fin N → ℝ) → GameTree N
  | decision : (player : Fin N) → (left : GameTree N) → (right : GameTree N) → GameTree N

/-- Backward induction: solve a game by starting at terminal nodes and working
    backwards to the root. At each decision node the moving player selects the
    branch yielding the higher payoff, given that all subsequent play is
    determined by the same procedure applied recursively. -/
noncomputable def backwardInduction {N : ℕ} : GameTree N → (Fin N → ℝ)
  | .terminal payoffs => payoffs
  | .decision player left right =>
    let leftVal := backwardInduction left
    let rightVal := backwardInduction right
    if leftVal player ≥ rightVal player then leftVal else rightVal