import Mathlib

/-- Definition 3.B.5 (MWG): A preference relation `pref` on `X` is **strictly convex** if
for every `x`, whenever `y ≿ x`, `z ≿ x`, and `y ≠ z`, the strict preference
`α • y + (1 - α) • z ≻ x` holds for all `α ∈ (0, 1)`. -/
def IsStrictlyConvexPreference {X : Type*} [AddCommGroup X] [Module ℝ X]
    (pref : X → X → Prop) : Prop :=
  ∀ x y z : X, y ≠ z → pref y x → pref z x →
    ∀ α : ℝ, 0 < α → α < 1 →
      pref (α • y + (1 - α) • z) x ∧ ¬pref x (α • y + (1 - α) • z)