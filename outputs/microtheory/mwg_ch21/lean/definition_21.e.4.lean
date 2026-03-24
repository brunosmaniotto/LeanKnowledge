import Mathlib

/-- A social choice function f on a set of preference profiles A is monotonic if,
    whenever x = f(prefs) and x maintains its relative position in prefs',
    then f(prefs') = x. Here we model preferences as linear orders on X,
    and "maintains position" means: for every agent i, every alternative y,
    if x ≿_i y in the original profile then x ≿'_i y in the new profile. -/
def IsMonotonicSCF {I : Type*} {X : Type*} [DecidableEq X]
    (A : Set (I → X → X → Prop))
    (f : (I → X → X → Prop) → X) : Prop :=
  ∀ prefs prefs' : I → X → X → Prop,
    prefs ∈ A → prefs' ∈ A →
    let x := f prefs
    (∀ (i : I) (y : X), prefs i x y → prefs' i x y) →
    f prefs' = x