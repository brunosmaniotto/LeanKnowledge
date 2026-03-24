import Mathlib
open Topology

/--
With free entry and exit in the Cournot market with fixed costs k > 0 and constant
marginal cost c, the long-run equilibrium number of firms can be determined from
the zero-profit condition.
-/
theorem Exercise_4_11_b
    (k c : ℝ)
    (hk : k > 0)
    (hc : c ≥ 0)
    -- Inverse demand P(Q) is decreasing; Q is aggregate output
    (P : ℝ → ℝ)
    -- Per-firm equilibrium output as a function of number of firms
    (q_star : ℕ → ℝ)
    -- In a symmetric Cournot equilibrium with J firms, each firm's profit is
    -- (P(J · q*(J)) - c) · q*(J) - k
    -- Free entry drives this to zero:
    (J : ℕ)
    (hJ : J ≥ 1)
    (hq_pos : q_star J > 0)
    -- Zero-profit condition: revenue minus variable cost minus fixed cost = 0
    (h_zero_profit : (P (J * q_star J) - c) * q_star J = k)
    -- This means price exceeds marginal cost by exactly k / q*(J)
    : P (J * q_star J) - c = k / q_star J := by
  have hq_ne : q_star J ≠ 0 := ne_of_gt hq_pos
  field_simp at h_zero_profit ⊢
  linarith