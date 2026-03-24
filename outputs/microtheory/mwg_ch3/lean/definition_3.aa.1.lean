import Mathlib

open Filter Topology
open Topology

/-- A Walrasian demand correspondence `x` is upper hemicontinuous at `(pBar, wBar)` if
for every sequence `(pSeq n, wSeq n) → (pBar, wBar)` and every sequence `xSeq n ∈ x(pSeq n, wSeq n)`
that converges to `xBar`, we have `xBar ∈ x(pBar, wBar)`. -/
def IsUpperHemicontinuousAt
    {L : ℕ} -- number of goods
    (x : (Fin L → ℝ) → ℝ → Set (Fin L → ℝ)) -- demand correspondence x(p, w)
    (pBar : Fin L → ℝ) (wBar : ℝ) : Prop :=
  ∀ (pSeq : ℕ → Fin L → ℝ) (wSeq : ℕ → ℝ) (xSeq : ℕ → Fin L → ℝ) (xBar : Fin L → ℝ),
    Filter.Tendsto pSeq atTop (nhds pBar) →
    Filter.Tendsto wSeq atTop (nhds wBar) →
    (∀ n, xSeq n ∈ x (pSeq n) (wSeq n)) →
    Filter.Tendsto xSeq atTop (nhds xBar) →
    xBar ∈ x pBar wBar