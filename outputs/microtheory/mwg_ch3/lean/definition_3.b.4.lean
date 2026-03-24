import Mathlib

/-- A preference relation `pref` on a real vector space `X` is convex if for every `x`,
    the upper contour set `{y | pref y x}` is convex: whenever `y ≿ x` and `z ≿ x`,
    we have `α • y + (1 - α) • z ≿ x` for all `α ∈ [0, 1]`. -/
def IsConvexPreference {X : Type*} [AddCommMonoid X] [Module ℝ X] (pref : X → X → Prop) : Prop :=
  ∀ (x y z : X), pref y x → pref z x →
    ∀ (α : ℝ), 0 ≤ α → α ≤ 1 → pref (α • y + (1 - α) • z) x