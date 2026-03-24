import Mathlib
open Topology

theorem Example_12E2 (a b c K : ℝ) (ha : a > c) (hc : c > 0) (hb : b > 0) :
  (K > 0 ∧ (a - c)^2 / (4 * b) > K) →
  { J : ℕ | J > 0 ∧ (if J = 1 then (a - c)^2 / (4 * b) else 0) ≥ K } = {1} := by
  -- Define monopoly profit as a local abbreviation for readability.
  let π_m := (a - c)^2 / (4 * b)
  -- Assume K > 0 and monopoly profit π_m > K.
  rintro ⟨hK_pos, h_πm_gt_K⟩
  -- To prove the sets are equal, we show they have the same elements using extensionality.
  ext n
  -- Simplify the set membership statements.
  simp only [Set.mem_setOf_eq, Set.mem_singleton_iff]
  -- The goal is to prove: (n > 0 ∧ (if n = 1 then π_m else 0) ≥ K) ↔ n = 1
  constructor
  · -- Direction 1 (→): If n firms are profitable, then n must be 1.
    rintro ⟨_, hn_profit⟩
    -- We split on the `if` condition within the profit hypothesis.
    split_ifs at hn_profit with h_eq
    · -- Case 1: n = 1. The goal is to prove n = 1, which is true by assumption.
      exact h_eq
    · -- Case 2: n ≠ 1. The profit is 0, so hn_profit becomes 0 ≥ K.
      -- This contradicts our assumption K > 0.
      exfalso
      linarith [hn_profit, hK_pos]
  · -- Direction 2 (←): If n = 1, then it's a profitable number of firms.
    rintro rfl
    -- We must show that n=1 satisfies the conditions for being in the set.
    -- The goal becomes: 1 > 0 ∧ (if 1 = 1 then π_m else 0) ≥ K
    -- `simp` will simplify `1 > 0` to `True` and evaluate the `if`.
    simp
    -- The goal is now `π_m ≥ K`.
    -- This follows from the hypothesis `h_πm_gt_K` which is `π_m > K`.
    linarith [h_πm_gt_K]