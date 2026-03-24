import Mathlib

theorem claim_M_C_g :
    (deriv (deriv (fun x : ℝ => -(x ^ 4))) 0 = 0) ∧
    (let x := (0 : ℝ); let y := (1 : ℝ); let t := (1 : ℝ) / 2;
     -(t * x + (1 - t) * y) ^ 4 > t * (-(x ^ 4)) + (1 - t) * (-(y ^ 4))) := by
  constructor
  · have h1 : (fun x : ℝ => -(x ^ 4)) = fun x => -1 * x ^ 4 := by ext x; ring
    rw [h1]
    simp [deriv_pow]
  · norm_num