import Mathlib

/-- A preference relation on a subset of a normed space is locally nonsatiated
if for every point and every ε > 0, there exists a strictly preferred point
within distance ε. -/
structure LocallyNonsatiated {X : Type*} [NormedAddCommGroup X] [NormedSpace ℝ X]
    (S : Set X) (pref : X → X → Prop) : Prop where
  exists_preferred : ∀ x ∈ S, ∀ ε > (0 : ℝ), ∃ x' ∈ S, ‖x' - x‖ < ε ∧ pref x' x ∧ ¬pref x x'