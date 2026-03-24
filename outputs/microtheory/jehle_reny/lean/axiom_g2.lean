import Mathlib

/-- Axiom G2 (Transitivity): For any three gambles g, g', g'' in 𝒢,
    if g ≿ g' and g' ≿ g'', then g ≿ g''. -/
abbrev Axiom_G2 (G : Type*) (pref : G → G → Prop) : Prop :=
  Transitive pref