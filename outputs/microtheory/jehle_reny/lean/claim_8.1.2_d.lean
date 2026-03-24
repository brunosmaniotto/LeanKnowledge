import Mathlib

theorem single_crossing_property
    (πl πh a b : ℝ)
    (hπl_pos : 0 < πl) (hπl_lt_one : πl < 1)
    (hπh_pos : 0 < πh) (hπh_lt_one : πh < 1)
    (hπ : πl < πh)
    (ha : 0 < a) (hb : 0 < b) :
    πl * a / ((1 - πl) * b + πl * a) <
    πh * a / ((1 - πh) * b + πh * a) := by
  have hdl : 0 < (1 - πl) * b + πl * a := by nlinarith
  have hdh : 0 < (1 - πh) * b + πh * a := by nlinarith
  rw [div_lt_div_iff₀ hdl hdh]
  nlinarith [mul_pos ha hb]