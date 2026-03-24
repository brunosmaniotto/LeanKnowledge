import Mathlib

open BigOperators
open Topology

/-- Short-run market supply function (Def 4.1 / Equation 4.2).
    Given `J` firms, each with individual supply `q j p w`,
    market supply is `q^s(p, w) = ∑_j q_j(p, w)`. -/
noncomputable def shortRunMarketSupply
    (J : ℕ) {W : Type*}
    (q : Fin J → ℝ → W → ℝ)
    (p : ℝ) (w : W) : ℝ :=
  ∑ j : Fin J, q j p w