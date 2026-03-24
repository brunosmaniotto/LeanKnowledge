import Mathlib

/-- Axiom 5' (Convexity): if x ≿ y then any convex combination of x and y is also ≿ y.
    Either this or strict convexity rules out concave-to-the-origin indifference segments.
    We show: if x¹ ~ x² (indifferent) and convexity holds, then for any t ∈ [0,1],
    the convex combination xᵗ satisfies xᵗ ≿ x², ruling out xᵗ being strictly worse. -/
theorem Claim_1_2_1_m
    {X : Type*}
    (pref : X → X → Prop)
    (mix : X → X → ℝ → X)
    -- Convexity axiom (Axiom 5'): if x ≿ y, then mix x y t ≿ y for t ∈ [0,1]
    (convexity : ∀ x y : X, pref x y → ∀ t : ℝ, 0 ≤ t → t ≤ 1 → pref (mix x y t) y)
    -- Two points on the same indifference set
    (x1 x2 : X)
    (h_indiff : pref x1 x2 ∧ pref x2 x1)
    -- t ∈ [0,1]
    (t : ℝ) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    -- The convex combination is weakly preferred to x2 (cannot be in the strictly-worse set)
    pref (mix x1 x2 t) x2 := by
  exact convexity x1 x2 h_indiff.1 t ht0 ht1