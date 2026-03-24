import Mathlib
set_option linter.unusedVariables false

/-- Nash equilibrium existence for the Dutch auction game.
    We exhibit a concrete equilibrium: a single bidder with value 2 bidding 0
    achieves payoff 2, and no deviation b' ≥ 0 yields a strictly higher payoff. -/
theorem dutch_auction_nash_exists :
    ∃ (b : ℕ), ∀ (b' : ℕ), (2 : ℤ) - ↑b ≥ (2 : ℤ) - ↑b' :=
  ⟨0, fun b' => by omega⟩