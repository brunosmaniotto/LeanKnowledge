import Mathlib

open Finset BigOperators
open BigOperators

/-- Definition 2.F.1 (MWG). A Walrasian demand function `x` satisfies the
    **weak axiom of revealed preference (WA)** if for any two price-wealth
    situations `(p, w)` and `(p', w')`: whenever `p · x(p', w') ≤ w` and
    `x(p', w') ≠ x(p, w)`, then `p' · x(p, w) > w'`. -/
def SatisfiesWeakAxiom {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ)) : Prop :=
  ∀ (p p' : Fin L → ℝ) (w w' : ℝ),
    ∑ i : Fin L, p i * (x p' w') i ≤ w →
    x p' w' ≠ x p w →
    ∑ i : Fin L, p' i * (x p w) i > w'