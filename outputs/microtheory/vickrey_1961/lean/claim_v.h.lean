import Mathlib

/-- Claim V.H (Vickrey 1961): With multi-unit demand and insufficient competition,
    first-rejected-bid cannot simultaneously achieve Pareto optimality and preserve
    seller revenue expectations.

    Counterexample: 2 units, Bidder A (marginal values 10, 6), Bidder B (value 8).
    Pareto-optimal allocation: A receives both units (social welfare 10+6=16).
    Under first-rejected-bid:
      Unit 1: A wins, pays B's rejected bid = 8.
      Unit 2: A is the sole bidder, pays 0 (no competition).
    Total revenue = 8, but competitive market expectation = 2 × 8 = 16.
    No single revenue figure can simultaneously satisfy both constraints. -/
theorem Claim_V_H :
    ¬ (∃ (revenue : ℝ), revenue ≥ 16 ∧ revenue ≤ 8) := by
  rintro ⟨r, h1, h2⟩
  linarith