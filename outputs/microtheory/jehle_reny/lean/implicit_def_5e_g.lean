import Mathlib
open Topology

/-- `CoreReplica F replicate core r` is the set C_r of feasible allocations in economy E₁
whose r-fold replications lie in the core of the r-replica economy E_r.
- `F`: feasible allocation set in E₁
- `replicate r x`: the r-fold copy of allocation x (each agent's bundle repeated r times)
- `core r`: the core of the r-replica economy E_r
C_r = {x ∈ F | replicate r x ∈ core r} -/
def CoreReplica {Alloc : Type*} {RAlloc : ℕ → Type*}
    (F : Set Alloc)
    (replicate : (r : ℕ) → Alloc → RAlloc r)
    (core : (r : ℕ) → Set (RAlloc r))
    (r : ℕ) : Set Alloc :=
  {x ∈ F | replicate r x ∈ core r}