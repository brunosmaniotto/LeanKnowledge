import Mathlib

-- Let K be a field and V, W be vector spaces over K.
-- Let f be a linear map from V to W.

-- Sub-lemma 1: The range of a linear map from a finite-dimensional space is finite-dimensional.
lemma range_is_finite_dimensional {K V W : Type*} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V] [AddCommGroup W] [Module K W] (f : V →ₗ[K] W) : FiniteDimensional K (LinearMap.range f) := by
  -- This is a standard theorem in Mathlib. The proof relies on the fact that
  -- the image of a finite spanning set of V is a finite spanning set of the range of f.
  exact LinearMap.finiteDimensional_range f

-- Sub-lemma 2: The dimension of the range is equal to the dimension of the quotient space V / ker(f).