import Mathlib
open Topology

noncomputable def marginal_contribution
    {I : Type*} [Fintype I] [DecidableEq I]
    (v : Finset I → ℝ)
    (π : I → ℕ)
    (i : I) : ℝ :=
  v (Finset.univ.filter fun h => π h ≤ π i) -
  v (Finset.univ.filter fun h => π h < π i)