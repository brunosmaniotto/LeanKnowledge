import Mathlib
open Topology

/-- The consumer's Engel function for fixed prices `p`: maps wealth `w` to
    the demanded bundle `x(p, w)` in `ℝ^L`. -/
noncomputable def engelFunction {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) : ℝ → (Fin L → ℝ) :=
  x p

/-- The wealth expansion path `E_p = {x(p, w) : w > 0}`: the image of the
    Engel function over strictly positive wealth levels. -/
noncomputable def wealthExpansionPath {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {bundle | ∃ w : ℝ, 0 < w ∧ x p w = bundle}