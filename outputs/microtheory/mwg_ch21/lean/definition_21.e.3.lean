import Mathlib

/-- Alternative `x` maintains its position from profile `prefs` to profile `prefs'`
if for every agent `i` and every alternative `y`, whenever `x` is weakly preferred
to `y` under `prefs i`, then `x` is also weakly preferred to `y` under `prefs' i`.
Equivalently, for every agent, the lower contour set of `x` under `prefs i` is
contained in the lower contour set of `x` under `prefs' i`. -/
def MaintainsPosition {X : Type*} {I : Type*} (x : X)
    (prefs prefs' : I → X → X → Prop) : Prop :=
  ∀ i : I, ∀ y : X, prefs i x y → prefs' i x y