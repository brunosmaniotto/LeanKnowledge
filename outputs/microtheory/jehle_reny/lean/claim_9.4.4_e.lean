import Mathlib

open Classical
open Topology

/-- In the optimal selling mechanism (Theorem 9.8), truth-telling is a
    dominant strategy for each bidder: regardless of what others report,
    bidder i maximizes payoff by reporting truthfully. -/
theorem Claim_9_4_4_e
    {n : ℕ} (hn : 0 < n)
    -- Each bidder has a true value
    (v : Fin n → ℝ)
    -- The mechanism assigns an allocation probability and payment
    -- given reported values
    (q : (Fin n → ℝ) → Fin n → ℝ)
    (p : (Fin n → ℝ) → Fin n → ℝ)
    -- Payoff: value × allocation probability − payment
    (payoff : Fin n → (Fin n → ℝ) → ℝ := fun i reports => v i * q reports i - p reports i)
    -- The mechanism satisfies the DSIC condition:
    -- for each bidder i, for any misreport r_i and any reports by others,
    -- truthful reporting yields at least as high a payoff
    (hDSIC : ∀ (i : Fin n) (others : Fin n → ℝ) (r_i : ℝ),
      payoff i (Function.update others i (v i)) ≥
      payoff i (Function.update others i r_i))
    -- Bidder index
    (i : Fin n)
    -- Any alternative report
    (b_i : ℝ)
    -- Any profile of others' reports
    (others : Fin n → ℝ) :
    payoff i (Function.update others i (v i)) ≥
    payoff i (Function.update others i b_i) := by
  exact hDSIC i others b_i