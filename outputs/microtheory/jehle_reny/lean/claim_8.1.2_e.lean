import Mathlib
open Topology

/-- If the insurance company knows the consumer's risk type, it accepts any policy (B, p)
    with positive expected profits and rejects if expected profits are negative.
    For low-risk: profit = p - π̲·B, for high-risk: profit = p - π̄·B. -/
theorem Claim_8_1_2_e
    (π_low π_high p B : ℝ)
    (hπ_pos_low : 0 < π_low) (hπ_pos_high : 0 < π_high)
    (hπ_order : π_low < π_high) :
    -- Low-risk: accept iff positive profit
    (p > π_low * B → p - π_low * B > 0) ∧
    (p < π_low * B → p - π_low * B < 0) ∧
    (p = π_low * B → p - π_low * B = 0) ∧
    -- High-risk: accept iff positive profit
    (p > π_high * B → p - π_high * B > 0) ∧
    (p < π_high * B → p - π_high * B < 0) ∧
    (p = π_high * B → p - π_high * B = 0) := by
  constructor <;> [skip; constructor <;> [skip; constructor <;> [skip; constructor <;> [skip; constructor]]]]
  all_goals intro h <;> linarith