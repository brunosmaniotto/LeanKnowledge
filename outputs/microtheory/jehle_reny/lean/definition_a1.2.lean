import Mathlib

/-- A relation `R` on `S` is complete if for all `x, y ∈ S`, `R x y ∨ R y x`.
    (MWG Definition A1.2) -/
def E.marketsComplete {S : Type*} (R : S → S → Prop) : Prop :=
  ∀ x y : S, R x y ∨ R y x