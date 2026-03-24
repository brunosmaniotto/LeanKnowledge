import Mathlib

theorem integral_domain_char_zero_infinite_order (D : Type) [CommRing D] [IsDomain D] (h_char_zero : CharP D 0) (x : D) (hx_ne_zero : x ≠ 0) : addOrderOf x = 0 := by
  by_contra h_finite
  set n := addOrderOf x with hn_def
  have h_n_pos : 0 < n := pos_of_ne_zero h_finite
  have h_nsmul_zero : n • x = 0 := addOrderOf_nsmul_eq_zero x
  rw [nsmul_eq_mul] at h_nsmul_zero
  rcases eq_zero_or_eq_zero_of_mul_eq_zero h_nsmul_zero with h_cast_zero | hx_zero
  · have h_cast_eq_zero_iff : (n : D) = 0 ↔ 0 ∣ n := CharP.cast_eq_zero_iff D 0 n
    rw [h_cast_eq_zero_iff] at h_cast_zero
    have : n = 0 := by simpa using h_cast_zero
    linarith [h_n_pos, this]
  · exact hx_ne_zero hx_zero