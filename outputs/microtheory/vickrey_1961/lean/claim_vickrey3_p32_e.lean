import Mathlib

open Real

/-- In a first-price auction where player 2 follows x = v/2, if v₁ > b,
    then bidding b/2 instead of v₁/2 is a profitable deviation:
    the payoff v₁ - b/2 strictly exceeds v₁ - v₁/2 when v₁ > b > 0,
    demonstrating that x = v/2 is not a Nash equilibrium. -/
theorem claim_vickrey3_p32_e
    (v₁ b : ℝ) (hb : 0 < b) (hv : v₁ > b) :
    (v₁ - b / 2) > (v₁ - v₁ / 2) := by
  linarith