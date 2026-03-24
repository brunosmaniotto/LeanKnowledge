import Mathlib
open Topology

-- Declare variables for market size (M) as a real number.
variable (M : ℝ)

-- Assume positive market size (M > 0).
variable (hM : M > 0)

/-
  Definition of the indifferent consumer's location ẑ as given by the problem statement.
  This is a function of p₁, p₂, and t.
  We use `(1:ℝ)/2` and `(2:ℝ)` for explicit Real type for numeric literals.
-/
noncomputable def z_indifferent_loc (p₁ p₂ t : ℝ) : ℝ :=
  ((1:ℝ)/2) + (p₂ - p₁) / ((2:ℝ) * t)

/-
  Proof that z_indifferent_loc satisfies the indifference condition: p₁ + t*z = p₂ + t*(1-z).
  We require `t > 0` for `field_simp` to handle division by `t`.
-/
theorem indifferent_consumer_satisfies_equation (p₁ p₂ t : ℝ) (ht : t > 0) :
    p₁ + t * (z_indifferent_loc p₁ p₂ t) = p₂ + t * (1 - (z_indifferent_loc p₁ p₂ t)) := by
  unfold z_indifferent_loc
  -- `field_simp` simplifies fractions, using `ht.ne` which states `t ≠ 0` because `t > 0`.
  field_simp [ht.ne]
  -- `ring` simplifies algebraic expressions.
  ring

/-
  Define Firm 1's demand function x₁ as given by the problem statement.
  This is a function of p₁, p₂, t, and M.
  The middle case `M(t+p₂-p₁)/(2t)` is equivalent to `M * z_indifferent_loc p₁ p₂ t`.
-/
noncomputable def x1_demand_func (p₁ p₂ t M : ℝ) : ℝ :=
  if p₁ > p₂ + t then 0
  else if p₁ < p₂ - t then M
  else M * (z_indifferent_loc p₁ p₂ t)

/-
  Helper theorem to show that Firm 1's demand in the middle case,
  `M(t+p₂-p₁)/(2t)`, is indeed equal to `M * z_indifferent_loc`.
-/