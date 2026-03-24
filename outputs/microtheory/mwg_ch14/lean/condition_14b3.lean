import Mathlib

/--
At a solution to the principal-agent problem (14.B.2), the first-order condition
of the Lagrangian with respect to the wage w(π) yields:
  -f(π|e) + γ · v'(w(π)) · f(π|e) = 0
which, for f(π|e) > 0, simplifies to 1 / v'(w(π)) = γ.
-/
theorem Condition_14B3
    (f_val : ℝ)       -- f(π|e), the density at profit level π
    (v' : ℝ)          -- v'(w(π)), marginal utility of wage
    (γ : ℝ)           -- Lagrange multiplier on reservation utility constraint
    (hf_pos : f_val > 0)
    (hv'_pos : v' > 0)
    (hFOC : -f_val + γ * v' * f_val = 0) :
    1 / v' = γ := by
  have hf_ne : f_val ≠ 0 := ne_of_gt hf_pos
  have hv'_ne : v' ≠ 0 := ne_of_gt hv'_pos
  -- From the FOC: -f_val + γ * v' * f_val = 0
  -- => γ * v' * f_val = f_val
  -- => γ * v' = 1
  -- => 1 / v' = γ
  field_simp
  nlinarith