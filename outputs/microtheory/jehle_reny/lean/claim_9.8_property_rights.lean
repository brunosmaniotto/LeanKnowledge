import Mathlib

theorem Claim_9_8_property_rights : ∀ (t_s : ℝ), 0 ≤ t_s → t_s ≤ 1 → t_s < 1 → (t_s ^ 2 + 2 * t_s - 1) / 2 < t_s := by
  intro t_s ht0 ht1 ht1'
  nlinarith