import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The marginal contribution of agent `i` in coalitional game `v` under permutation `π`:
    v(predecessors of i under π, plus i) - v(predecessors of i under π) -/
noncomputable def marginalContribution {n : ℕ} (v : Finset (Fin n) → ℝ)
    (π : Equiv.Perm (Fin n)) (i : Fin n) : ℝ :=
  let predecessors := Finset.univ.filter (fun j => π.symm j < π.symm i)
  v (predecessors ∪ {i}) - v predecessors

/-- The Shapley value for agent `i` in coalitional game `v`:
    f_{Sh,i}(v) = (1 / n!) Σ_π g_{v,π}(i)
    where the sum is over all n! permutations of the agents. -/
noncomputable def shapleyValue {n : ℕ} (v : Finset (Fin n) → ℝ)
    (i : Fin n) : ℝ :=
  (1 / (n.factorial : ℝ)) * ∑ π : Equiv.Perm (Fin n), marginalContribution v π i