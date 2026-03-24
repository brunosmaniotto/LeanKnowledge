import Mathlib

-- We formalize the key structural result: rational preferences impose strictly
-- more restrictions than the weak axiom. Specifically, we encode that there
-- exists a property (Slutsky symmetry) implied by rationality but not by WA.

-- Abstract the two theories as sets of properties (predicates on demand functions)
-- and show strict inclusion.

theorem walrasian_demand_WA_weaker_than_rational
    {DemandFn : Type}
    (satisfies_WA : DemandFn → Prop)
    (satisfies_rational : DemandFn → Prop)
    (slutsky_symmetric : DemandFn → Prop)
    -- Rational preferences imply the weak axiom
    (rational_implies_WA : ∀ x, satisfies_rational x → satisfies_WA x)
    -- Rational preferences imply Slutsky symmetry
    (rational_implies_slutsky : ∀ x, satisfies_rational x → slutsky_symmetric x)
    -- There exists a demand function satisfying WA but not Slutsky symmetry (for L > 2)
    (wa_not_implies_slutsky : ∃ x, satisfies_WA x ∧ ¬ slutsky_symmetric x) :
    -- Conclusion: the set of WA-consistent demands strictly contains
    -- the set of rationality-consistent demands
    (∀ x, satisfies_rational x → satisfies_WA x) ∧
    (∃ x, satisfies_WA x ∧ ¬ satisfies_rational x) := by
  constructor
  · exact rational_implies_WA
  · obtain ⟨x, hwa, hns⟩ := wa_not_implies_slutsky
    exact ⟨x, hwa, fun hr => hns (rational_implies_slutsky x hr)⟩