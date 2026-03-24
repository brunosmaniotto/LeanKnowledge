import Mathlib

/-- Walrasian equilibrium ↔ offer curve intersection (Edgeworth box, Claim 15.B.a).
    We axiomatize: in a two-consumer Edgeworth box, an allocation different from the
    endowment is a Walrasian equilibrium iff it lies on both consumers' offer curves. -/
theorem walrasian_eq_iff_offer_curve_intersection
    {Alloc : Type*}
    (ω : Alloc)
    (offerCurve₁ offerCurve₂ : Set Alloc)
    (isWalrasianEq : Set Alloc)
    -- Axiom 1: Every Walrasian equilibrium lies on both offer curves
    (h_we_to_oc : ∀ a, a ∈ isWalrasianEq → a ∈ offerCurve₁ ∧ a ∈ offerCurve₂)
    -- Axiom 2: Every offer curve intersection away from ω is a Walrasian equilibrium
    (h_oc_to_we : ∀ a, a ≠ ω → a ∈ offerCurve₁ → a ∈ offerCurve₂ → a ∈ isWalrasianEq)
    (a : Alloc)
    (ha : a ≠ ω) :
    a ∈ isWalrasianEq ↔ a ∈ offerCurve₁ ∧ a ∈ offerCurve₂ := by
  constructor
  · exact h_we_to_oc a
  · rintro ⟨h1, h2⟩
    exact h_oc_to_we a ha h1 h2