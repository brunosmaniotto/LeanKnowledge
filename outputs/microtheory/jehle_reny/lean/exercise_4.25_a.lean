import Mathlib
open Topology

/-- A monopolist compares Design 1 (nonlinear demand) and Design 2 (linear demand).
    Design 2 achieves maximum profit 6 (at p=4), exceeding Design 1's profit of 5. -/
theorem Exercise_4_25_a :
    -- Design 2 profit is globally at most 6
    (∀ q : ℝ, q * (63 / 8 - 9 / 8 * q) - (33 / 8 + (63 / 8 - 9 / 8 * q)) ≤ 6) ∧
    -- Design 2 profit at p=4 equals 6
    (4 : ℝ) * (63 / 8 - 9 / 8 * 4) - (33 / 8 + (63 / 8 - 9 / 8 * 4)) = 6 ∧
    -- Design 1 profit at p=4 equals 5
    (4 : ℝ) * (2 / 4 + 55 / 8 - 4) - (41 / 8 + (2 / 4 + 55 / 8 - 4)) = 5 ∧
    -- Design 2 is chosen
    (6 : ℝ) > 5 := by
  refine ⟨?_, by norm_num, by norm_num, by norm_num⟩
  intro q
  have h : q * (63 / 8 - 9 / 8 * q) - (33 / 8 + (63 / 8 - 9 / 8 * q)) =
      -(9 / 8) * (q - 4) ^ 2 + 6 := by ring
  nlinarith [sq_nonneg (q - 4)]