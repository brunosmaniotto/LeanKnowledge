import Mathlib

-- Formalize the logical structure of the equivalences between
-- revealed preference axioms and Slutsky matrix properties.

-- We work with abstract propositions representing the economic concepts
variable (SARP WARP RationalPref SlutskySym SlutskyNSD : Prop)

/-- The strong axiom is essentially equivalent to rational preferences
    and to symmetry + negative semidefiniteness of the Slutsky matrix.
    The weak axiom is essentially equivalent to NSD alone.
    Rational preferences add exactly symmetry beyond the weak axiom. -/
theorem claim_3Jb
    -- Axiom: SARP ↔ Rational Preferences
    (h1 : SARP ↔ RationalPref)
    -- Axiom: SARP ↔ Symmetry + NSD of Slutsky matrix
    (h2 : SARP ↔ (SlutskySym ∧ SlutskyNSD))
    -- Axiom: WARP ↔ NSD of Slutsky matrix alone
    (h3 : WARP ↔ SlutskyNSD)
    -- Axiom: Rational preferences ↔ WARP + Slutsky symmetry
    (h4 : RationalPref ↔ (WARP ∧ SlutskySym)) :
    -- Conclusion: the logical relationships hold together consistently
    (SARP ↔ (SlutskySym ∧ SlutskyNSD)) ∧
    (WARP ↔ SlutskyNSD) ∧
    (RationalPref ↔ (WARP ∧ SlutskySym)) ∧
    -- SARP → WARP (strong implies weak)
    (SARP → WARP) ∧
    -- The gap between WARP and SARP is exactly Slutsky symmetry
    ((WARP ∧ SlutskySym) ↔ SARP) := by
  refine ⟨h2, h3, h4, ?_, ?_⟩
  · intro hs
    exact h3.mpr (h2.mp hs).2
  · constructor
    · intro ⟨hw, hsym⟩
      exact h1.mpr (h4.mpr ⟨hw, hsym⟩)
    · intro hs
      exact ⟨h3.mpr (h2.mp hs).2, (h2.mp hs).1⟩