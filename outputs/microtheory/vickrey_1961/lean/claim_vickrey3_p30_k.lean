import Mathlib

open MeasureTheory intervalIntegral

theorem claim_vickrey3_p30_k (N : ℕ) (hN : 0 < N) :
    ∫ x in (0:ℝ)..1, (N : ℝ) * x ^ N = (N : ℝ) / ((N : ℝ) + 1) := by
  have hN1_ne : (N : ℝ) + 1 ≠ 0 := by positivity
  have hderiv : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      HasDerivAt (fun y => (N : ℝ) / ((N : ℝ) + 1) * y ^ (N + 1))
        ((N : ℝ) * x ^ N) x := by
    intro x _
    have hcd := (hasDerivAt_pow (N + 1) x).const_mul ((N : ℝ) / ((N : ℝ) + 1))
    convert hcd using 1
    push_cast; field_simp
  have hint : IntervalIntegrable (fun x => (N : ℝ) * x ^ N) volume 0 1 :=
    (continuous_const.mul (continuous_pow N)).intervalIntegrable 0 1
  rw [integral_eq_sub_of_hasDerivAt hderiv hint]
  have h0 : (0 : ℝ) ^ (N + 1) = 0 := zero_pow (by omega)
  simp [h0]