import Mathlib

-- This file demonstrates that for a linear map φ, scaling it by a scalar λ
-- from the center of the ring R results in another linear map.
-- The proof is built by first proving the two required properties (additivity
-- and homogeneity) as separate lemmas, and then using them to prove the main theorem.

-- Sub-lemma 1: Additivity
-- This lemma shows that the function `x ↦ λ • φ x` preserves addition.
-- This property holds for any scalar `c`, not just those in the center.
lemma map_add_of_smul_linear_map {R G H : Type*} [Semiring R] [AddCommMonoid G] [AddCommMonoid H] [Module R G] [Module R H] (φ : G →ₗ[R] H) (c : R) (x y : G) : c • φ (x + y) = c • φ x + c • φ y := by
  -- We use the linearity of φ to distribute it over the sum x + y.
  -- Then, we use the distributive property of scalar multiplication over addition.
  -- The `simp` tactic automates this chain of rewrites.
  simp [φ.map_add, smul_add]

-- Sub-lemma 2: Scalar Homogeneity
-- This lemma shows that the function `x ↦ λ • φ x` preserves scalar multiplication,
-- provided the scalar `λ` is in the center of the ring `R`.