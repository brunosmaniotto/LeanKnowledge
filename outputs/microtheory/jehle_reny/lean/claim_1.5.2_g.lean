import Mathlib
open Topology

/-- Claim 1.5.2(g): Theorems 1.10 and 1.16 provide empirically testable restrictions
    on consumer demand. Utility maximization implies homogeneity, budget balancedness,
    Slutsky symmetry, and Slutsky negative semidefiniteness. These restrictions serve
    as necessary conditions: any estimated demand system violating them cannot be
    consistent with utility maximization. -/
theorem Claim_1_5_2_g
    (utilityMaximization : Prop)
    (homogeneity : Prop)
    (budgetBalancedness : Prop)
    (slutskySymmetric : Prop)
    (slutskyNSD : Prop)
    (h_homog : utilityMaximization → homogeneity)
    (h_budget : utilityMaximization → budgetBalancedness)
    (h_symm : utilityMaximization → slutskySymmetric)
    (h_nsd : utilityMaximization → slutskyNSD) :
    utilityMaximization →
      (homogeneity ∧ budgetBalancedness ∧ slutskySymmetric ∧ slutskyNSD) :=
  fun h => ⟨h_homog h, h_budget h, h_symm h, h_nsd h⟩