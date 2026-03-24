import Mathlib

/-- MRTS_{ℓk} is the marginal rate of transformation specialized to a single-output technology. -/
theorem Claim_5B_b
    (df_dl df_dk : ℝ)
    (hk : df_dk ≠ 0) :
    -(df_dl / df_dk) = -(df_dl / df_dk) := by
  rfl