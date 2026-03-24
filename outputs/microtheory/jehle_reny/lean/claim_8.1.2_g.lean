import Mathlib

/-- In any sequential equilibrium, all policies (B, p) strictly above the high-risk
    zero-profit line (p > π̄·B) are accepted by the insurance company.
    For any belief β ∈ [0,1], expected profit p − [β·πL + (1−β)·πH]·B > 0. -/
theorem Claim_8_1_2_g
    (πL πH p B : ℝ)
    (hπ : πL ≤ πH)
    (hB : 0 ≤ B)
    (h_above : p > πH * B)
    (β : ℝ) (hβ0 : 0 ≤ β) (hβ1 : β ≤ 1) :
    p - (β * πL + (1 - β) * πH) * B > 0 := by
  have h1 : β * πL + (1 - β) * πH ≤ πH := by nlinarith
  nlinarith