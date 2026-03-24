import Mathlib

-- This lemma proves that for a non-zero vector `x` in a vector space over a division ring,
-- if a scalar multiple `c • x` is zero, then the scalar `c` must be zero.
-- This corresponds to `step2_prove_scalar_implication` from the problem description.
lemma step2_prove_scalar_implication {K G : Type*} [DivisionRing K] [AddCommGroup G] [Module K G] {x : G} (hx : x ≠ 0) : ∀ (c : K), c • x = 0 → c = 0 := by
  -- Introduce the scalar `c` and the hypothesis `h : c • x = 0`.
  intro c h
  -- The lemma `smul_eq_zero` states `c • x = 0 ↔ c = 0 ∨ x = 0`. This holds because `K` is a
  -- division ring, which implies `NoZeroSMulDivisors K G`.
  -- We apply the forward direction of this equivalence to `h` to get `c = 0 ∨ x = 0`.
  have h_or := smul_eq_zero.mp h
  -- We are given `hx : x ≠ 0`, which is the negation of the right side of the disjunction.
  -- `Or.resolve_right` takes a disjunction `P ∨ Q` and a proof of `¬Q`, and concludes `P`.
  -- Here, `P` is `c = 0` and `Q` is `x = 0`.
  exact h_or.resolve_right hx

-- Main Theorem: A non-zero singleton set is linearly independent.
-- Note: The problem description uses `e` for the identity of `G`, but in a `Module` context,
-- `G` is an `AddCommGroup` whose identity is denoted `0`. The hypothesis `x ≠ e` is
-- correctly formalized as `x ≠ 0`.