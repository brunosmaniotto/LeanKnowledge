import Mathlib

variable {L : Type*} [TopologicalSpace L]

structure ContinuousPreference (L : Type*) [TopologicalSpace L] where
  pref : L → L → Prop
  refl : ∀ a, pref a a
  trans : ∀ a b c, pref a b → pref b c → pref a c
  total : ∀ a b, pref a b ∨ pref b a
  upper_closed : ∀ b, IsClosed {a | pref a b}
  lower_closed : ∀ b, IsClosed {a | pref b a}

def IsUtilityFor (U : L → ℝ) (pref : L → L → Prop) : Prop :=
  ∀ x y, pref x y ↔ U x ≥ U y