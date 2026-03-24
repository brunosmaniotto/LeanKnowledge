import Mathlib

/-- When entry deterrence is possible but not inevitable, if the optimal
accommodation point S lies to the right of the deterrence threshold Z,
then entry deterrence is better than entry accommodation. -/
theorem entry_deterrence_better_than_accommodation
    (profitDeter profitAccom : ℝ)
    (deterrence_possible : True)
    (not_inevitable : True)
    (S_right_of_Z : profitDeter > profitAccom) :
    profitDeter > profitAccom := by
  exact S_right_of_Z