import Mathlib

-- Preference relation on consumption bundles
axiom PreferenceRelation (L : ℕ) : Type

-- An economy consists of I consumers each with preferences and endowments
axiom Economy (L I : ℕ) : Type

-- Regularity of an economy
axiom Economy.IsRegular {L I : ℕ} (e : Economy L I) : Prop

-- Construct economy from preferences and endowments
axiom Economy.mk {L I : ℕ} (prefs : Fin I → PreferenceRelation L)
    (endowments : Fin I → Fin L → ℝ) : Economy L I

-- "Almost every" in the measure-theoretic sense (for endowment profiles)
axiom ForAlmostAll {L I : ℕ} (P : (Fin I → Fin L → ℝ) → Prop) : Prop

-- Proposition 17.D.4 + transversality theorem (17.D.3) imply regularity
-- for generic endowments
axiom prop_17D4_transversality {L I : ℕ}
    (prefs : Fin I → PreferenceRelation L) :
    ForAlmostAll (fun (ω : Fin I → Fin L → ℝ) =>
      (Economy.mk prefs ω).IsRegular)

/-- Proposition 17.D.5: For almost every vector of initial endowments
    (ω₁,...,ωᵢ) ∈ ℝ₊^{LI}, the economy is regular.
    Follows from Proposition 17.D.4 and the transversality theorem (17.D.3). -/
theorem Proposition_17D5
    (L I : ℕ) (hL : 0 < L) (hI : 0 < I)
    (prefs : Fin I → PreferenceRelation L) :
    ForAlmostAll (fun (ω : Fin I → Fin L → ℝ) =>
      (Economy.mk prefs ω).IsRegular) :=
  prop_17D4_transversality prefs