import Mathlib

open BigOperators LinearMap Submodule FiniteDimensional

variable {K : Type*} [Field K] {n : ℕ}

local notation "V" => Fin n → K

/-- The linear form defined by coefficients `α`. -/
def linearFormOfCoeffs (α : V) : V →ₗ[K] K :=
  ∑ i, α i • (proj i : V →ₗ[K] K)