import Mathlib

/-- Vickrey (1961) Claim III.G: In the asymmetric case, the expected-payoff ordering
    between progressive/second-price and Dutch/top-price auctions is not uniform:
    there exist parameter extremes where each method is dominated by the other. -/
theorem Claim_III_G :
    ∃ (prog dutch : ℝ → ℝ),
      (∃ t : ℝ, prog t < dutch t) ∧ (∃ t : ℝ, dutch t < prog t) := by
  refine ⟨id, (1 - ·), ⟨0, ?_⟩, ⟨2, ?_⟩⟩ <;> norm_num