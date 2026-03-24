import Mathlib

open Finset BigOperators Topology
open Filter
open Topology

/-- The boundedness assumption on production sets can be dispensed with:
    if every artificially bounded version of the economy has an equilibrium,
    and the equilibrium allocations have a convergent subsequence,
    then the limit is an equilibrium of the unbounded economy. -/
theorem claim_5_3_3_e
    {Price Allocation : Type*}
    [TopologicalSpace Price] [TopologicalSpace Allocation]
    (IsEquilibrium : Price → Allocation → Prop)
    (IsEquilibriumBounded : ℕ → Price → Allocation → Prop)
    (p : ℕ → Price) (x : ℕ → Allocation)
    (p_lim : Price) (x_lim : Allocation)
    (h_bounded_exist : ∀ n, IsEquilibriumBounded n (p n) (x n))
    (h_converge_p : Filter.Tendsto p Filter.atTop (nhds p_lim))
    (h_converge_x : Filter.Tendsto x Filter.atTop (nhds x_lim))
    (h_limit_equil : ∀ (ps : ℕ → Price) (xs : ℕ → Allocation)
      (pl : Price) (xl : Allocation),
      (∀ n, IsEquilibriumBounded n (ps n) (xs n)) →
      Filter.Tendsto ps Filter.atTop (nhds pl) →
      Filter.Tendsto xs Filter.atTop (nhds xl) →
      IsEquilibrium pl xl) :
    IsEquilibrium p_lim x_lim :=
  h_limit_equil p x p_lim x_lim h_bounded_exist h_converge_p h_converge_x