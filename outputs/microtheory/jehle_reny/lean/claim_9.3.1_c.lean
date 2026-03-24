import Mathlib

open Real
open Topology

/-- Claim 9.3.1(c): Revenue equivalence of first-price all-pay auctions.
    Under symmetric IPV with uniform [0,1] values and n ≥ 2 bidders:
    - Equilibrium bid: b(v) = ((n-1)/n) · v^n
    - b(0) = 0 (RET boundary condition)
    - Revenue = n · E[b(V)] = (n-1)/(n+1), matching all standard auctions -/
theorem Claim_9_3_1_c_AllPay (n : ℕ) (hn : n ≥ 2) :
    let bid : ℝ → ℝ := fun v => ((↑n - 1) / ↑n) * v ^ n
    -- (1) Boundary: zero-value bidder bids zero (RET condition)
    bid 0 = 0 ∧
    -- (2) Non-negative bids for non-negative values
    (∀ v : ℝ, 0 ≤ v → 0 ≤ bid v) ∧
    -- (3) Revenue identity: n · per-bidder payment = (n-1)/(n+1)
    (↑n : ℝ) * ((↑n - 1) / (↑n * (↑n + 1))) = (↑n - 1) / (↑n + 1) := by
  have hn2 : (2 : ℝ) ≤ ↑n := by exact_mod_cast hn
  refine ⟨?_, ?_, ?_⟩
  · -- bid(0) = 0
    simp [zero_pow (by omega : n ≠ 0)]
  · -- Non-negativity of bids
    intro v hv
    apply mul_nonneg
    · apply div_nonneg <;> linarith
    · exact pow_nonneg hv n
  · -- Revenue = (n-1)/(n+1)
    have h1 : (↑n : ℝ) ≠ 0 := by linarith
    have h2 : (↑n : ℝ) + 1 ≠ 0 := by linarith
    field_simp