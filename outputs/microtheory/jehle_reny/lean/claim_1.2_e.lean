import Mathlib

/-- For any bundle x⁰ in X, the three sets ≺(x⁰), ∼(x⁰), and ≻(x⁰) partition X.
    Given completeness of ≿, every x satisfies exactly one of:
    x ≺ x⁰ (strictly worse), x ∼ x⁰ (indifferent), or x ≻ x⁰ (strictly better). -/
theorem Claim_1_2_e {X : Type*} (pref : X → X → Prop)
    (complete : ∀ x y : X, pref x y ∨ pref y x)
    (x0 : X) :
    ∀ x : X,
      (pref x0 x ∧ ¬pref x x0) ∨
      (pref x x0 ∧ pref x0 x) ∨
      (pref x x0 ∧ ¬pref x0 x) := by
  intro x
  have := complete x x0
  have := complete x0 x
  tauto