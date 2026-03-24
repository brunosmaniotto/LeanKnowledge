import Mathlib
open Topology
open BigOperators

/-- In a three-player matching pennies variant, when all players mix uniformly
    (each action with probability 1/2), every player's expected payoff is zero.
    Player 3 gets no help from player 2: without player 2, the game reduces
    to standard matching pennies between players 1 and 3 (also zero payoff). -/
theorem Claim_7_7_f :
    -- Part 1: Under uniform mixing (all 1/2), each player's expected payoff is 0
    let mixedPayoff (payoffs : Fin 2 → Fin 2 → Fin 2 → ℚ) : ℚ :=
      ∑ a₁ : Fin 2, ∑ a₂ : Fin 2, ∑ a₃ : Fin 2,
        (1/2) * (1/2) * (1/2) * payoffs a₁ a₂ a₃
    -- Player 1 wins (+1) if coins match with player 3, loses (-1) otherwise
    -- Player 3 is the opposite. Player 2's payoff is symmetric/zero-sum.
    let u₁ : Fin 2 → Fin 2 → Fin 2 → ℚ := fun a₁ _a₂ a₃ =>
      if a₁ = a₃ then 1 else -1
    let u₃ : Fin 2 → Fin 2 → Fin 2 → ℚ := fun a₁ _a₂ a₃ =>
      if a₁ = a₃ then -1 else 1
    let u₂ : Fin 2 → Fin 2 → Fin 2 → ℚ := fun _a₁ _a₂ _a₃ => (0 : ℚ)
    -- Part 2: Two-player matching pennies (without player 2) also gives zero
    let twoPlayerPayoff (payoffs : Fin 2 → Fin 2 → ℚ) : ℚ :=
      ∑ a₁ : Fin 2, ∑ a₃ : Fin 2, (1/2) * (1/2) * payoffs a₁ a₃
    let v₃ : Fin 2 → Fin 2 → ℚ := fun a₁ a₃ =>
      if a₁ = a₃ then -1 else 1
    mixedPayoff u₁ = 0 ∧ mixedPayoff u₂ = 0 ∧ mixedPayoff u₃ = 0 ∧
    twoPlayerPayoff v₃ = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide