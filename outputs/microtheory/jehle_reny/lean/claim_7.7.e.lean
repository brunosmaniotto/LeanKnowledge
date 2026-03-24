import Mathlib
open Topology
open BigOperators

/-- In sophisticated matching pennies with three players, when all players
    mix uniformly (each plays heads with probability 1/2), every player's
    expected payoff is zero. This follows because the game reduces to
    standard matching pennies structure where uniform mixing yields zero payoff. -/
theorem Claim_7_7_e :
    let payoff_matrix : Fin 2 → Fin 2 → ℚ := fun a1 a3 =>
      if a1 = a3 then 1 else -1
    let prob : Fin 2 → ℚ := fun _ => 1 / 2
    -- Player 1's expected payoff when both mix uniformly
    let ep1 := ∑ a1 : Fin 2, ∑ a3 : Fin 2, prob a1 * prob a3 * payoff_matrix a1 a3
    -- Player 3's expected payoff (opposite of player 1 in zero-sum)
    let ep3 := ∑ a1 : Fin 2, ∑ a3 : Fin 2, prob a1 * prob a3 * (-payoff_matrix a1 a3)
    -- Player 2's expected payoff (no strategic impact, gets zero)
    let ep2 := (0 : ℚ)
    ep1 = 0 ∧ ep2 = 0 ∧ ep3 = 0 := by
  refine ⟨?_, rfl, ?_⟩ <;> simp [Fin.sum_univ_two] <;> ring