import Mathlib

/-- In matching pennies, sequential equilibrium (consistent beliefs via Bayes' rule
    + sequential rationality) requires each player to be indifferent. The indifference
    condition p * (-1) + (1-p) * 1 = p * 1 + (1-p) * (-1) uniquely forces p = 1/2. -/
theorem matching_pennies_sequential_equilibrium
    (p q : ℝ)
    (h_indiff_1 : p * (-1) + (1 - p) * 1 = p * 1 + (1 - p) * (-1))
    (h_indiff_2 : q * (-1) + (1 - q) * 1 = q * 1 + (1 - q) * (-1)) :
    p = 1 / 2 ∧ q = 1 / 2 := by
  constructor <;> linarith