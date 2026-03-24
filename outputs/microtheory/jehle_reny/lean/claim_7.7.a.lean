import Mathlib

theorem Claim_7_7_a
    (x xb y yb : ℝ)
    (hx : 0 < x) (hxb : 0 < xb)
    (hy : 0 < y) (hyb : 0 < yb)
    (hx_sum : x + xb = 1) (hy_sum : y + yb = 1) :
    0 < x * yb + xb * y ∧
    0 < x * y + xb * yb ∧
    x * yb / (x * yb + xb * y) + xb * y / (x * yb + xb * y) = 1 ∧
    x * y / (x * y + xb * yb) + xb * yb / (x * y + xb * yb) = 1 ∧
    (x * yb + xb * y) + (x * y + xb * yb) = 1 := by
  have hβ : 0 < x * yb + xb * y := by positivity
  have hγ : 0 < x * y + xb * yb := by positivity
  refine ⟨hβ, hγ, ?_, ?_, ?_⟩
  · rw [div_add_div_same, div_self hβ.ne']
  · rw [div_add_div_same, div_self hγ.ne']
  · nlinarith