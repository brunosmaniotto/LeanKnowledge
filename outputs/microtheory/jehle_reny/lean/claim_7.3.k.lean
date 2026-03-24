import Mathlib

theorem Claim_7_3_k :
    (1/3 : ℚ) * 6 + (2/3) * 3 = 4 ∧
    (1/3 : ℚ) * ((3/4) * 8 + (1/4) * 12) + (2/3) * 0 = 3 ∧
    (1/3 : ℚ) * 6 + (2/3) * ((3/4) * 4 + (1/4) * 12) = 6 ∧
    (1/2 : ℚ) * 4 + (1/3) * 3 + (1/6) * 6 = 4 := by
  exact ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩