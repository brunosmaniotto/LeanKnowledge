import Mathlib

/-- Social choice setup: alternatives X, I agents, each with rational preference ≿_i. -/
structure SocialChoiceSetup where
  X : Type*
  I : ℕ
  pref : Fin I → X → X → Prop
  pref_refl : ∀ i x, pref i x x
  pref_trans : ∀ i x y z, pref i x y → pref i y z → pref i x z
  pref_total : ∀ i x y, pref i x y ∨ pref i y x

namespace SocialChoiceSetup

def strictPref (S : SocialChoiceSetup) (i : Fin S.I) (x y : S.X) : Prop :=
  S.pref i x y ∧ ¬S.pref i y x