import Mathlib

open Real

theorem claim_vickrey3_p35_h
    (a k : ℝ)
    (hk : k < a ^ 2 / 4) :
    let disc := a ^ 2 - 4 * k
    let r2 := (a + Real.sqrt disc) / 2
    r2 ^ 2 - a * r2 + k = 0 := by
  simp only
  have hdisc : 0 ≤ a ^ 2 - 4 * k := by linarith
  have hsq := Real.sq_sqrt hdisc
  nlinarith [Real.sq_sqrt hdisc]