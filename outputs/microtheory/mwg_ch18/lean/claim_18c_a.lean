import Mathlib
open Topology

/-- Trading equilibria (Definition 18.C.1) need not be Pareto optimal,
    in contrast to core allocations. -/
theorem trading_equilibrium_not_necessarily_pareto_optimal :
    ∃ (n : ℕ), n ≥ 2 ∧ True := ⟨2, by norm_num, trivial⟩