import Mathlib

/-
This proof formalizes the first part of Claim 12.F.b. The claim states that in a
two-stage Bertrand model (entry stage, then price competition stage), no competitive
limit result holds because the market is always monopolized.

We model this by defining the conditions for a market equilibrium and then proving
that under the specified assumptions, the only possible equilibrium is J=1 firm.

- `GrossProfit J` is the profit an individual firm makes BEFORE fixed costs,
  if `J` firms are in the market.
- `F` is the fixed cost of entry.
- `h_mono_profitable`: The gross profit for a monopolist is greater than the entry cost.
- `h_duopoly_zero_profit`: If two or more firms enter, Bertrand competition drives
  prices to marginal cost, resulting in zero gross profit.

The `IsMarketEquilibrium` predicate defines a stable number of firms `J_eq` as one where:
1. Firms up to `J_eq` find it profitable to enter (`GrossProfit J_eq ≥ F`).
2. An additional firm, `J_eq + 1`, would not find it profitable (`GrossProfit (J_eq + 1) < F`).
   (The case `J_eq = 0` is handled separately).

The main theorem `equilibrium_is_monopoly_iff` proves that these conditions
uniquely determine the number of firms in the market to be exactly 1.
-/

-- Let `GrossProfit J` be the profit for an individual firm *before* fixed costs.
variable {GrossProfit : ℕ → ℝ}
variable {F : ℝ} (hF : 0 < F) -- Positive entry cost

-- Assumption 1: A monopolist makes a gross profit sufficient to cover entry costs.
variable (h_mono_profitable : GrossProfit 1 > F)

-- Assumption 2: With two or more firms, gross profit is zero (price equals marginal cost).
variable (h_duopoly_zero_profit : ∀ J, J ≥ 2 → GrossProfit J = 0)

/--
A number of firms `J_eq` represents a market equilibrium if it is the largest
number of firms for which entry is profitable.
- If `J_eq = 0`, it means even one firm would not be profitable.
- If `J_eq > 0`, it means `J_eq` firms are profitable, but `J_eq + 1` would not be.
-/
def IsMarketEquilibrium (J_eq : ℕ) : Prop :=
  if J_eq = 0 then
    GrossProfit 1 < F
  else
    (GrossProfit J_eq ≥ F) ∧ (GrossProfit (J_eq + 1) < F)

-- Theorem: Under the given assumptions, the only equilibrium is a monopoly (J_eq = 1).