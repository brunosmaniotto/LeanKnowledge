# Category Supplement: Linear Algebra

## Key imports
```lean
import Mathlib
open Matrix Finset BigOperators
```

## Core types
```
-- Vector spaces
Module R M              — module over ring R (vector space when R is a field)
Submodule R M           — submodule / subspace
LinearMap R M N         — linear map (also written M →ₗ[R] N)
LinearEquiv R M N       — linear isomorphism (also written M ≃ₗ[R] N)

-- Matrices
Matrix (Fin m) (Fin n) R — m × n matrix over R
Matrix.det A             — determinant
Matrix.trace A           — trace
Matrix.mul A B           — matrix multiplication
Matrix.transpose A       — transpose (also Aᵀ)

-- Dimension and basis
Module.rank R M          — rank/dimension (as cardinal)
Basis ι R M              — basis indexed by ι
LinearIndependent R v    — family v is linearly independent
Submodule.span R s       — span of a set
```

## Key lemmas
```
-- Determinant
Matrix.det_mul           : det (A * B) = det A * det B
Matrix.det_transpose     : det Aᵀ = det A
Matrix.det_one           : det (1 : Matrix n n R) = 1
Matrix.det_zero          : det (0 : Matrix n n R) = 0 (when n ≥ 1)

-- Matrix operations
Matrix.mul_assoc         : A * B * C = A * (B * C)
Matrix.transpose_mul     : (A * B)ᵀ = Bᵀ * Aᵀ
Matrix.transpose_transpose : Aᵀᵀ = A

-- Linear maps
LinearMap.map_add        : f (x + y) = f x + f y
LinearMap.map_smul       : f (r • x) = r • f x
LinearMap.ker            : kernel of a linear map
LinearMap.range          : range/image of a linear map

-- Dimension
rank_add_rank_le_rank_comp : rank inequality for compositions
```

## Common patterns
```lean
-- Work with concrete matrices via Fin indices
def myMatrix : Matrix (Fin 2) (Fin 2) ℝ := !![1, 2; 3, 4]

-- Prove matrix equalities
ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply]

-- Use `Finset.sum` for matrix multiplication definition
-- Matrix.mul_apply : (A * B) i j = ∑ k, A i k * B k j
```

## Common pitfalls
1. **Matrix indices**: Matrices use `Fin n` for indices. Use `fin_cases` to case-split on indices.
2. **`!![]` notation**: The `!![a, b; c, d]` syntax creates concrete matrices. Needs `open Matrix`.
3. **Ring vs Field**: Many results need `Field R` (not just `Ring R`). Check if you need invertibility.
4. **`ext` for matrices**: Prove `A = B` by `ext i j` then show `A i j = B i j`.
5. **`simp [Matrix.mul_apply]`**: Key lemma for expanding matrix multiplication.

## Worked example: Determinant of product
```lean
import Mathlib
open Matrix

theorem det_product {n : Type*} [Fintype n] [DecidableEq n]
    {R : Type*} [CommRing R]
    (A B : Matrix n n R) :
    det (A * B) = det A * det B :=
  det_mul A B
```
