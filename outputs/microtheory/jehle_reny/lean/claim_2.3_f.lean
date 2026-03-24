import Mathlib

/-- If a choice function x(p, y) satisfies WARP and budget balancedness,
    then it satisfies homogeneity of degree zero and negative semidefiniteness
    of the Slutsky matrix. This combines Claim_2.3_c (homogeneity) and
    Claim_2.3_e (NSD of Slutsky matrix). -/
theorem Claim_2_3_f
    (WARP : Prop) (BudgetBalancedness : Prop)
    (HomogeneityDegZero : Prop) (NSD_Slutsky : Prop)
    -- Claim_2.3_c: WARP + balancedness → homogeneity of degree zero
    (claim_2_3_c : WARP → BudgetBalancedness → HomogeneityDegZero)
    -- Claim_2.3_e: WARP + balancedness → NSD of Slutsky matrix
    (claim_2_3_e : WARP → BudgetBalancedness → NSD_Slutsky)
    (hwarp : WARP) (hbal : BudgetBalancedness) :
    HomogeneityDegZero ∧ NSD_Slutsky :=
  ⟨claim_2_3_c hwarp hbal, claim_2_3_e hwarp hbal⟩