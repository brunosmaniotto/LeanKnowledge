import Mathlib

/-- Completeness axiom (G1): For any two gambles g and g' in G,
    either g ≿ g' or g' ≿ g. -/
def Completeness (G : Type*) (pref : G → G → Prop) : Prop :=
  ∀ g g' : G, pref g g' ∨ pref g' g