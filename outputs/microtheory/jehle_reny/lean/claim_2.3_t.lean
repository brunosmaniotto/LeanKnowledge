import Mathlib

/-- Varian (1982) described a set of bundles such that every x in the set satisfies
    u(x) > u(y) for every utility function rationalising the data, and Knoblauch (1992)
    showed this set is complete (it contains ALL such bundles).
    Combined: x ∈ VarianSet y ↔ ∀ rationalising u, u(x) > u(y). -/
theorem Claim_2_3_t
    {X : Type*}
    (y : X)
    (Rationalizes : (X → ℝ) → Prop)
    (VarianSet : Set X)
    (h_varian : ∀ x ∈ VarianSet, ∀ u : X → ℝ, Rationalizes u → u x > u y)
    (h_knoblauch : ∀ x : X, (∀ u : X → ℝ, Rationalizes u → u x > u y) → x ∈ VarianSet) :
    ∀ x : X, x ∈ VarianSet ↔ (∀ u : X → ℝ, Rationalizes u → u x > u y) := by
  intro x
  exact ⟨fun hx u hu => h_varian x hx u hu, h_knoblauch x⟩