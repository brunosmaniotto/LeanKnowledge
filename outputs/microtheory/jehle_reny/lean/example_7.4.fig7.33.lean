import Mathlib

open Finset BigOperators

theorem Example_7_4_Fig7_33 :
    (1/3 : ℚ) * 6 + (2/3) * 3 = 4 ∧
    (1/3 : ℚ) * ((3/4) * 8 + (1/4) * 12) + (2/3) * 0 = 3 ∧
    (1/3 : ℚ) * 6 + (2/3) * ((3/4) * 4 + (1/4) * 12) = 6 ∧
    (1/2 : ℚ) * 4 + (1/3) * 3 + (1/6) * 6 = 4 := by
  constructor <;> norm_num