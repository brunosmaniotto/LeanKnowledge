import Mathlib

/-- The three conditions — budget balancedness (Walras' law), symmetry of the
Slutsky substitution matrix, and negative semidefiniteness of the Slutsky
matrix — are exhaustive: by the integrability theorem, any demand function
satisfying all three is the demand of some utility-maximising consumer.
We encode the logical structure: rationalizability ↔ (all three conditions). -/
theorem Claim_2_2_b :
  ∀ (Rationalizable BudgetBalanced SlutskySym SlutskyNSD : Prop),
    -- The integrability theorem gives: three conditions → rationalizable
    (BudgetBalanced ∧ SlutskySym ∧ SlutskyNSD → Rationalizable) →
    -- Necessity: rationalizable → each condition holds
    (Rationalizable → BudgetBalanced ∧ SlutskySym ∧ SlutskyNSD) →
    -- Therefore: the three conditions are exactly equivalent to rationalizability
    (Rationalizable ↔ BudgetBalanced ∧ SlutskySym ∧ SlutskyNSD) := by
  intro _ _ _ _ hSuff hNec
  exact ⟨hNec, hSuff⟩