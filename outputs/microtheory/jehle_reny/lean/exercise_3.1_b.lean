import Mathlib
open Topology

theorem Exercise_3_1_b (f : ℝ → ℝ) (z : ℝ) (hz : z > 0)
    (f' : ℝ) (hf : HasDerivAt f f' z) :
    HasDerivAt (fun x => f x / x) ((f' - f z / z) / z) z := by
  have hz' : z ≠ 0 := hz.ne'
  have h := hf.div (hasDerivAt_id z) hz'
  refine h.congr_deriv ?_
  simp only [id]
  field_simp