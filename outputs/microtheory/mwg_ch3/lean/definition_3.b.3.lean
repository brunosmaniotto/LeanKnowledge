import Mathlib

/-- Definition 3.B.3 (MWG). A preference relation `pref` on a metric space `X` is
locally nonsatiated if for every `x ∈ X` and every `ε > 0`, there exists `y ∈ X`
with `dist y x < ε` and `y ≻ x` (i.e., `y` is strictly preferred to `x`). -/
def LocallyNonsatiated {X : Type*} [PseudoMetricSpace X]
    (pref : X → X → Prop) : Prop :=
  ∀ x : X, ∀ ε > 0, ∃ y : X, dist y x < ε ∧ pref y x ∧ ¬pref x y