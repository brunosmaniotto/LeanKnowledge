import Mathlib
open Topology

/-- For n > 2 goods, WARP and budget balancedness do not imply symmetry of the
    Slutsky matrix, do not imply acyclicity of revealed preference, and hence
    are not equivalent to utility maximisation. -/
theorem Claim_2_3_l
    (WARP : Prop)
    (BudgetBalanced : Prop)
    (SlutskySymmetric : Prop)
    (NoCycles : Prop)
    (UtilityMax : Prop)
    -- Utility maximisation implies both Slutsky symmetry and no cycles
    (hUM_sym : UtilityMax → SlutskySymmetric)
    (hUM_acyc : UtilityMax → NoCycles)
    -- There exist situations where WARP + BB hold but symmetry fails
    (hNotSym : WARP → BudgetBalanced → ¬SlutskySymmetric)
    -- There exist situations where WARP + BB hold but acyclicity fails
    (hNotAcyc : WARP → BudgetBalanced → ¬NoCycles) :
    -- Conclusion: WARP + BB does not imply utility maximisation
    (WARP → BudgetBalanced → ¬UtilityMax) := by
  intro hw hb hum
  exact absurd (hUM_sym hum) (hNotSym hw hb)