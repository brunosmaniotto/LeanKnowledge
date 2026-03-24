import Mathlib

/-- An allocation in the r-fold replica economy Eᵣ.
    `ReplicaAllocation I r X` assigns a consumption bundle in `X` to each
    consumer indexed by type `i ∈ Fin I` and copy number `q ∈ Fin r`.
    That is, `x i q` is the bundle of the q-th consumer of type i. -/
abbrev ReplicaAllocation (I : ℕ) (r : ℕ) (X : Type*) :=
  Fin I → Fin r → X