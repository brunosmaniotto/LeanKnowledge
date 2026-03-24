import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Player i's expected utility under mixed strategy profile m.
    u_i(m) = Σ_s (∏_j m_j(s_j)) · u_i(s), where the product reflects
    independent randomization across players. -/
noncomputable def expectedUtility
    {I : Type*} [DecidableEq I] [Fintype I]
    {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
    (u : (∀ i, S i) → I → ℝ)
    (m : ∀ i, S i → ℝ)
    (i : I) : ℝ :=
  ∑ s : (∀ j, S j), (∏ j : I, m j (s j)) * u s i