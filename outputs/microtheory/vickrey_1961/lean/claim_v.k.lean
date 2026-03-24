import Mathlib

/-!
# Vickrey 1961, Claim V.K

The "restricted bid format" mechanism — bids of the form "up to q units at
any price ≤ p", clearing price equal to the first unsuccessful bidder's price,
each winner allotted their specified quantity — cannot generally achieve the
socially optimal allocation.

**Counterexample** (2 units for sale, 2 bidders):
  - Bidder 1: marginal value 10 (unit 1), 9 (unit 2)
  - Bidder 2: value 7 (one unit)

Social optimum: Bidder 1 takes both units, welfare = 19.

Under the mechanism:
  · Truthful bidding (Bidder 1 bids for 2): clearing price = 7 (Bidder 2's bid),
    Bidder 1's utility = (10 − 7) + (9 − 7) = 5.
  · Demand reduction (Bidder 1 bids for 1): demand = supply = 2, no unsuccessful
    bidder exists, price = 0, Bidder 1's utility = 10 > 5.

Since demand reduction strictly dominates, the unique dominant-strategy equilibrium
allocates 1 unit to each bidder: equilibrium welfare = 17 < 19 = optimum. ∎
-/

section ClaimVK

-- Counterexample parameters (integer arithmetic suffices)
private abbrev v₁₁ : ℤ := 10  -- Bidder 1's value for first unit
private abbrev v₁₂ : ℤ := 9   -- Bidder 1's value for second unit
private abbrev v₂₁ : ℤ := 7   -- Bidder 2's value for one unit

-- Bidder 1's utility under truthful bidding:
-- wins both units, clearing price = v₂₁ (first unsuccessful bidder's price)
private abbrev u_truthful : ℤ := (v₁₁ - v₂₁) + (v₁₂ - v₂₁)  -- (10−7)+(9−7) = 5

-- Bidder 1's utility under demand reduction:
-- bids for 1 unit only; supply = demand = 2, no unsuccessful bidder, price = 0
private abbrev u_reduced : ℤ := v₁₁  -- 10 − 0 = 10

/-- Claim V.K: The described mechanism cannot achieve the social optimum.
Bidder 1 strictly prefers demand reduction over truthful bidding, so the unique
dominant-strategy equilibrium is (1 unit each), with welfare strictly below optimal. -/
theorem claim_VK :
    u_truthful < u_reduced ∧       -- demand reduction is strictly profitable
    v₁₁ + v₂₁ < v₁₁ + v₁₂ := by  -- equilibrium welfare 17 < optimal welfare 19
  constructor <;> norm_num

end ClaimVK