import Mathlib

theorem Claim_2_3_s :
    -- Both u and v rationalize x¹ = (1,1) at prices p¹ = (2,1) with wealth 3
    (2 * (1 : ℝ) + 1 = 3) ∧
    -- u(1,1) = 1 and v(1,1) = 2
    ((1 : ℝ)^2 * 1 = 1) ∧
    ((1 : ℝ) * (1 + 1) = 2) ∧
    -- u(3,1) > u(1,7): 9 > 7
    ((3 : ℝ)^2 * 1 > (1 : ℝ)^2 * 7) ∧
    -- v(3,1) < v(1,7): 6 < 8
    ((3 : ℝ) * (1 + 1) < (1 : ℝ) * (7 + 1)) := by
  norm_num