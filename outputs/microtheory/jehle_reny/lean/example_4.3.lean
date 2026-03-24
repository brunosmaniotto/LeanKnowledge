import Mathlib

open BigOperators Finset
open Topology

/-- Example 4.3: Long-run equilibrium with constant returns to scale.
    With π_j(p,k) = k(p²/16 - 1) and demand q^d = 294/p:
    - Zero profit for all k > 0 iff p = 4
    - Market clearing at p = 4 gives J·k = 147 -/
theorem Example_4_3 :
    -- (1) Zero-profit condition: p²/16 = 1 ↔ p = 4 (for p > 0)
    (∀ p : ℝ, 0 < p → (p ^ 2 / 16 = 1 ↔ p = 4)) ∧
    -- (2) Market clearing: 294/4 = (4/8) * J * k ↔ J * k = 147
    (∀ J k : ℝ, (294 / 4 : ℝ) = 4 / 8 * (J * k) ↔ J * k = 147) ∧
    -- (3) Any positive J with k = 147/J satisfies J * k = 147
    (∀ J : ℝ, 0 < J → J * (147 / J) = 147) := by
  refine ⟨fun p hp => ?_, fun J k => ?_, fun J hJ => ?_⟩
  · constructor
    · intro h
      have : p ^ 2 = 16 := by linarith
      nlinarith [sq_nonneg (p - 4), sq_nonneg (p + 4)]
    · intro h; subst h; norm_num
  · constructor
    · intro h; linarith
    · intro h; linarith
  · field_simp