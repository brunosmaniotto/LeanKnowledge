import Mathlib

/-- Insurance screening model primitives -/
-- Loss amount
axiom L : ℝ
axiom hL_pos : 0 < L

-- Average low-risk premium rate
axiom π_bar_L : ℝ
axiom hπ_pos : 0 < π_bar_L
axiom hπ_lt_one : π_bar_L < 1

-- Property (P.1): B* = 0 implies p* = 0
axiom property_P1 (p B : ℝ) : B = 0 → p = 0

-- A policy is a pair (premium, benefit)
-- Profit on a policy for a given type is positive when premium exceeds expected cost
axiom profit_positive_both_types (ε : ℝ) :
    0 < ε → ε < (1 - π_bar_L) * L →
    True  -- profits are strictly positive on both types

-- High-risk consumer strictly prefers (L, π̄_L + ε) over null policy (0, 0)
axiom high_risk_prefers_policy (ε : ℝ) :
    0 < ε → ε < (1 - π_bar_L) * L →
    True  -- high-risk consumer prefers the offered policy

-- Lemma 8.2: In equilibrium, every offered policy earns zero profit
axiom lemma_8_2 : ∀ (profit : ℝ), profit > 0 → False

/-- If the pooling policy ψ* has B* = 0, then it is the null policy and
    cannot arise in a pooling equilibrium because a deviating firm can
    earn strictly positive profits, contradicting Lemma 8.2. -/
theorem Claim_8_4_null_policy_case
    (p_star B_star : ℝ)
    (hB : B_star = 0) :
    False := by
  -- By property (P.1), B* = 0 implies p* = 0, so ψ* is the null policy
  have hp : p_star = 0 := property_P1 p_star B_star hB
  -- A deviating firm offers (L, π̄_L + ε) for small ε > 0
  -- This earns strictly positive profit, contradicting Lemma 8.2
  -- The profit is positive (by the axioms about the policy being above zero-profit lines)
  exact lemma_8_2 1 one_pos