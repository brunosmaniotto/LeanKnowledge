import Mathlib

-- Define a social choice function type, and a relation type for preferences.
-- I: Type for individuals
-- X: Type for social states
-- R: Preference relation (X → X → Prop)
-- Profile: I → (X → X → Prop)
-- c: Social choice function (Profile → X)

/-- A social choice function `c` is monotonic if, whenever `c(R_orig) = x` and
    for every individual `i`, their new preferences `R_new i` strictly improve `x`
    over any `y` distinct from `x` (compared to `R_orig i`), then `c(R_new) = x`.
    For the purpose of this exercise, the "strictly improve" part is interpreted
    as `R_orig i x y → R_new i x y`. -/
def MonotonicSCF {I X : Type*} (c : (I → X → X → Prop) → X) : Prop :=
  ∀ (R_orig R_new : I → X → X → Prop) (x : X),
    c R_orig = x →
    (∀ (i : I) (y : X), y ≠ x → (R_orig i x y → R_new i x y)) →
    c R_new = x