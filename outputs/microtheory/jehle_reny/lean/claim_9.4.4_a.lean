import Mathlib

open BigOperators

/-- Marginal revenue in an auction: MR_i(v_i) = v_i - (1 - F_i(v_i)) / f_i(v_i).
    This equals the net rate (v_i * f_i(v_i) - (1 - F_i(v_i))) / f_i(v_i),
    reflecting revenue gain v_i * f_i(v_i) minus the incentive-compatibility
    cost 1 - F_i(v_i) from reducing payments to higher types. -/
theorem marginal_revenue_formula
    (v_i F_i f_i : ℝ)
    (hf : f_i ≠ 0) :
    v_i - (1 - F_i) / f_i = (v_i * f_i - (1 - F_i)) / f_i := by
  field_simp