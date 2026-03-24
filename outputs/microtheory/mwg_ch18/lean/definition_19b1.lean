import Mathlib
open Topology

/-- A (state-)contingent commodity vector for L physical commodities and S states.
    Entry `val ℓ s` is a title to receive one unit of good ℓ if and only if state s occurs.
    The full contingent commodity vector lives in ℝ^(LS). -/
structure ContingentCommodityVector (L : ℕ) (S : ℕ) where
  val : Fin L → Fin S → ℝ

namespace ContingentCommodityVector

/-- The commodity vector received if state s occurs: (x_1s, ..., x_Ls) ∈ ℝ^L. -/
def stateBundle (x : ContingentCommodityVector L S) (s : Fin S) : Fin L → ℝ :=
  fun ℓ => x.val ℓ s

end ContingentCommodityVector