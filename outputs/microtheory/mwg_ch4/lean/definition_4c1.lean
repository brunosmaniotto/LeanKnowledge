import Mathlib
open BigOperators
open Topology

/-- The weak axiom of revealed preference for an aggregate demand function.
    Given demand function `x` mapping (price vector, wealth) to a consumption bundle,
    WA states: if bundle x(p', w') is affordable at (p, w) and the two
    demanded bundles differ, then x(p, w) is NOT affordable at (p', w'). -/
def WeakAxiom {n : ℕ} (x : (Fin n → ℝ) → ℝ → (Fin n → ℝ)) : Prop :=
  ∀ (p p' : Fin n → ℝ) (w w' : ℝ),
    (∑ i, p i * x p' w' i) ≤ w →
    x p w ≠ x p' w' →
    (∑ i, p' i * x p w i) > w'