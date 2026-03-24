import Mathlib
open Filter
open Topology

/-- Definition 3.C.1 (MWG): A preference relation `R` on a topological space `X`
is continuous if it is preserved under limits of sequences. -/
def IsContinuousPreference {X : Type*} [TopologicalSpace X] (R : X → X → Prop) : Prop :=
  ∀ (x y : X) (xn yn : ℕ → X),
    Filter.Tendsto xn Filter.atTop (nhds x) →
    Filter.Tendsto yn Filter.atTop (nhds y) →
    (∀ n, R (xn n) (yn n)) →
    R x y