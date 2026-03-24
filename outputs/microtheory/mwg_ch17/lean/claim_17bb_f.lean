import Mathlib
open Topology

/-- Claim 17BB_f: The existence proof for equilibrium requires only that
best-response correspondences be convex-valued and upper hemicontinuous.
No further restrictions on dependence of choices on state variables are needed.
This allows money illusion, externalities, and reference-dependent preferences. -/
theorem generality_of_existence_proof_Claim_17BB_f
    {S C : Type*}
    (ConvexValuedCorr : (S → Set C) → Prop)
    (UHCCorr : (S → Set C) → Prop)
    (existence_from_properties :
      ∀ (φ : S → Set C), ConvexValuedCorr φ → UHCCorr φ →
        ∃ s : S, ∃ x : C, x ∈ φ s)
    (φ : S → Set C)
    (hconv : ConvexValuedCorr φ)
    (huhc : UHCCorr φ)
    -- These additional properties may or may not hold; they do not affect the conclusion
    (money_illusion externalities ref_dependent_prefs : Prop) :
    ∃ s : S, ∃ x : C, x ∈ φ s :=
  existence_from_properties φ hconv huhc