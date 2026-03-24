import Mathlib

/-- For any bundle x⁰ in X, the three sets ≺(x⁰), ∼(x⁰), and ≻(x⁰) partition X.
    Given completeness of ≿, every x satisfies exactly one of:
    x ≺ x⁰ (strictly worse), x ∼ x⁰ (indifferent), or x ≻ x⁰ (strictly preferred). -/
theorem Claim_1_2_1_e {X : Type*} (R : X → X → Prop)
    (complete : ∀ x y : X, R x y ∨ R y x)
    (x0 x : X) :
    -- Exhaustive: every x falls into one of the three sets
    ((R x0 x ∧ ¬R x x0) ∨ (R x x0 ∧ R x0 x) ∨ (R x x0 ∧ ¬R x0 x)) ∧
    -- Mutually exclusive: no two sets overlap
    ¬((R x0 x ∧ ¬R x x0) ∧ (R x x0 ∧ R x0 x)) ∧
    ¬((R x0 x ∧ ¬R x x0) ∧ (R x x0 ∧ ¬R x0 x)) ∧
    ¬((R x x0 ∧ R x0 x) ∧ (R x x0 ∧ ¬R x0 x)) := by
  have h1 := complete x x0
  have h2 := complete x0 x
  tauto