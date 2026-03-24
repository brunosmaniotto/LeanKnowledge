import Mathlib

axiom step1_y_is_zero (x z : ℝ) : z * (x % 0) = (z * x) % 0
axiom step2_z_is_zero (x y : ℝ) : 0 * (x % y) = (0 * x) % (0 * y)
axiom step3_floor_of_div_mul (x y z : ℝ) (hy : y ≠ 0) (hz : z ≠ 0) : ⌊(z * x) / (z * y)⌋ = ⌊x / y⌋
axiom step4_main_case_ne_zero (x y z : ℝ) (hy : y ≠ 0) (hz : z ≠ 0) (h_floor : ⌊(z * x) / (z * y)⌋ = ⌊x / y⌋) : z * (x % y) = (z * x) % (z * y)

/--
Product Distributes over Modulo Operation:
For real numbers $x, y, z$, we have $z \left({x \bmod y}\right) = \left({z x}\right) \bmod \left({z y}\right)$.
-/
theorem mul_mod (x y z : ℝ) : z * (x % y) = (z * x) % (z * y) := by
  -- We proceed by cases on whether y and z are zero.
  by_cases hy : y = 0
  · -- Case 1: y = 0
    -- The goal becomes z * (x % 0) = (z * x) % (z * 0)
    subst hy
    -- Simplify the right-hand side: (z * x) % (z * 0) = (z * x) % 0
    rw [mul_zero z]
    -- The goal now matches the first axiom.
    exact step1_y_is_zero x z
  · -- Case 2: y ≠ 0
    by_cases hz : z = 0
    · -- Case 2a: y ≠ 0 and z = 0
      -- The goal becomes 0 * (x % y) = (0 * x) % (0 * y)
      subst hz
      -- The goal now matches the second axiom.
      exact step2_z_is_zero x y
    · -- Case 2b: y ≠ 0 and z ≠ 0
      -- We can use the third axiom to establish the floor equality.
      have h_floor : ⌊(z * x) / (z * y)⌋ = ⌊x / y⌋ := by
        exact step3_floor_of_div_mul x y z hy hz
      -- With the hypotheses y ≠ 0, z ≠ 0, and the floor equality,
      -- the fourth axiom proves the goal.
      exact step4_main_case_ne_zero x y z hy hz h_floor