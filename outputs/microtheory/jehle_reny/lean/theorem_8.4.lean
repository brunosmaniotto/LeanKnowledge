import Mathlib
open Topology

/-- Non-existence of pooling equilibria in insurance screening (Theorem 8.4).

    If both risk types pool on contract (B*, p*) with B* > 0, zero expected profit
    forces p* − πL·B* > 0 (low-risk are cross-subsidizing high-risk). The single-crossing
    property then yields a cream-skimming deviation that attracts only low-risk types
    at positive profit, contradicting subgame perfect equilibrium. -/
theorem Theorem_8_4
    -- Fraction α ∈ (0,1) of low-risk consumers
    (α : ℝ) (hα0 : 0 < α) (hα1 : α < 1)
    -- Risk probabilities with πL < πH (adverse selection)
    (πL πH : ℝ) (hπ : πL < πH)
    -- Pooling contract (B*, p*) with positive coverage
    (B p : ℝ) (hB : 0 < B)
    -- (P.1) Zero expected profit from Lemma 8.2
    (h_zero_profit : α * (p - πL * B) + (1 - α) * (p - πH * B) = 0)
    -- Single-crossing cream-skim: if low-risk are profitable at the pooling contract,
    -- a competitor can offer a nearby contract attracting only low-risk at positive
    -- profit, contradicting equilibrium (Lemma 8.3 + deviation argument)
    (h_cream_skim : p - πL * B > 0 → False) : False := by
  apply h_cream_skim
  -- Show p - πL * B > 0: at zero average profit, low-risk must be strictly profitable
  by_contra h
  push_neg at h
  -- Since πL < πH and B > 0, per-unit profit on low-risk exceeds that on high-risk
  have h1 : πL * B < πH * B := by nlinarith
  -- So high-risk are strictly unprofitable
  have h2 : p - πH * B < 0 := by linarith
  -- Weighted low-risk profit is non-positive (α > 0, margin ≤ 0)
  have h3 : α * (p - πL * B) ≤ 0 := by nlinarith
  -- Weighted high-risk profit is strictly negative ((1-α) > 0, margin < 0)
  have h4 : (1 - α) * (p - πH * B) < 0 := by nlinarith
  -- Total profit < 0, contradicting zero-profit condition
  linarith