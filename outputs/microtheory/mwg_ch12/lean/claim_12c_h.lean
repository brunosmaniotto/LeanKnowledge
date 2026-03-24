import Mathlib

open Real
open Topology

-- Define the types for price and quantity
abbrev Price := ℝ
abbrev Quantity := ℝ

theorem Claim_12C_h :
  -- Define the demand function and marginal cost for the theorem
  ∀ (x : Price → Quantity) (c : Price),
    -- Assumptions for the problem statement
    -- Marginal cost is positive
    c > 0 →
    -- Demand at marginal cost is positive
    x c > 0 →
    -- The Bertrand outcome (p₁* = p₂* = c) is no longer an equilibrium.
    -- This means there exists a deviation for firm 1 that yields higher profit.
    ∃ (ε : ℝ), ε > 0 ∧
      -- Profit of firm 1 when deviating to c + ε, with firm 2 at c.
      -- Firm 2's capacity: q_bar = (1/2) * x(c).
      -- Firm 2 sells its capacity (1/2) * x(c) at price c.
      -- Firm 1 captures the residual demand: x(c) - (1/2) * x(c) = (1/2) * x(c).
      -- Firm 1's profit: ((c + ε) - c) * ((1/2 : ℝ) * (x c)) = ε * ((1/2 : ℝ) * (x c)).
      (ε * ((1/2 : ℝ) * (x c))) >
      -- Profit of firm 1 when both are at c.
      -- With equal prices at marginal cost, firm 1 earns zero profit.
      -- Profit: (c - c) * ((x c) / 2) = 0.
      ((c - c) * ((x c) / 2)) :=
  by
    -- Introduce the variables and hypotheses
    intros x c hc_pos hxc_pos

    -- First, simplify the profit of firm 1 when both firms price at marginal cost `c`.
    -- This profit is (c - c) * ((x c) / 2), which simplifies to 0 * (x c / 2) = 0.
    have profit_at_cc_is_zero : (c - c) * ((x c) / 2) = 0 := by
      rw [sub_self c]
      rw [zero_mul]

    -- We need to find an `ε > 0` such that the deviation profit is strictly greater than the
    -- profit at (c,c) (which is 0).
    -- Let's choose `ε = 1`.
    use 1

    -- We need to prove two things for `ε = 1`:
    -- 1. `1 > 0`
    -- 2. `1 * ((1/2 : ℝ) * (x c)) > ((c - c) * ((x c) / 2))`

    constructor
    -- Proof for `1 > 0`
    · norm_num
    -- Proof for `1 * ((1/2 : ℝ) * (x c)) > ((c - c) * ((x c) / 2))`
    · rw [one_mul] -- Simplify the left side: `1 * expression` becomes `expression`
      -- Now the goal is `(1/2 : ℝ) * (x c) > ((c - c) * ((x c) / 2))`
      rw [profit_at_cc_is_zero] -- Use the proven equality to substitute the right side with 0
      -- Goal: `(1/2 : ℝ) * (x c) > 0`
      -- We use `mul_pos` which states that the product of two positive numbers is positive.
      apply mul_pos
      -- Proof for `(1/2 : ℝ) > 0`
      · norm_num
      -- Proof for `x c > 0`
      · exact hxc_pos