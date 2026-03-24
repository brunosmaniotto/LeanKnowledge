import Mathlib

open Finset
open Topology

/-- The Rawlsian social welfare function: welfare equals the minimum utility
    across all individuals. Maximizing this is equivalent to maximizing
    the welfare of society's worst-off member. -/
theorem Invoked_Dep_Rawls
    {I : Type*} [Fintype I] [Nonempty I] [DecidableEq I]
    (u : I → ℝ)
    (W_rawls : (I → ℝ) → ℝ)
    (hW : W_rawls = fun v => Finset.inf' Finset.univ Finset.univ_nonempty v)
    (u' : I → ℝ)
    (h_improve_worst : Finset.inf' Finset.univ Finset.univ_nonempty u'
                     > Finset.inf' Finset.univ Finset.univ_nonempty u) :
    W_rawls u' > W_rawls u := by
  subst hW
  exact h_improve_worst