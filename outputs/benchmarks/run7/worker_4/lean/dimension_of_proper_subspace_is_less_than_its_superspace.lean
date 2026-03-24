import Mathlib

-- Let K be a field and V be a vector space over K.

-- Sub-lemma 1: Any subspace of a finite-dimensional vector space is finite-dimensional.
-- This is a known instance in Mathlib, so the proof is just to find it.
lemma subspace_is_finite_dimensional {K V : Type*} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (W : Submodule K V) : FiniteDimensional K W := by
  -- This is a registered typeclass instance in Mathlib.
  -- `infer_instance` automatically finds it.
  infer_instance

-- Sub-lemma 2: The dimension of a subspace is less than or equal to the dimension of the ambient space.