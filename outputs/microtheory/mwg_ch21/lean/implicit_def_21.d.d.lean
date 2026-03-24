import Mathlib

/-- The class P_≥ of rational preference relations that are single-peaked with respect to
a linear order ≥ and have strict preferences (no two distinct alternatives are indifferent). -/
def IsSinglePeakedStrict {α : Type*} [LinearOrder α] (R : α → α → Prop) : Prop :=
  -- R is complete (rational/total)
  (∀ x y, R x y ∨ R y x) ∧
  -- R is transitive
  (∀ x y z, R x y → R y z → R x z) ∧
  -- There exists a peak such that R is monotone increasing up to the peak
  -- and monotone decreasing after the peak (single-peakedness w.r.t. ≥)
  (∃ peak : α,
    (∀ x y, x ≤ y → y ≤ peak → R y x) ∧
    (∀ x y, peak ≤ x → x ≤ y → R x y)) ∧
  -- No two distinct alternatives are indifferent (strict preferences)
  (∀ x y, x ≠ y → ¬(R x y ∧ R y x))