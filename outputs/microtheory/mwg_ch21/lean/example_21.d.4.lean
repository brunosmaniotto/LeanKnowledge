import Mathlib

-- We formalize the equivalence between single-peakedness and strict convexity
-- for continuous preference relations on a closed interval [a,b] with the
-- standard ordering.

-- Define a preference relation on a type
structure PreferenceRelation (X : Type*) where
  weakPref : X → X → Prop  -- x ≿ y
  strictPref : X → X → Prop  -- x ≻ y
  strict_iff : ∀ x y, strictPref x y ↔ (weakPref x y ∧ ¬weakPref y x)

noncomputable section

variable {a b : ℝ} (hab : a < b)

-- The interval [a,b]
def closedInterval (a b : ℝ) := Set.Icc a b

-- Single-peakedness: there exists a peak x* such that preference is monotone
-- on each side of x*