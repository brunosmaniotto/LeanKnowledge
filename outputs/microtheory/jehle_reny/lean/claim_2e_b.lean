import Mathlib

theorem claim_2E_b
    (u_a u_b u_c α : ℝ)
    (hα₀ : 0 < α) (hα₁ : α < 1)
    (h_vnm : u_b = α * u_a + (1 - α) * u_c)
    (h_ne : u_b ≠ u_c) :
    (u_a - u_b) / (u_b - u_c) = (1 - α) / α := by
  have hα_ne : α ≠ 0 := ne_of_gt hα₀
  have h_diff_ne : u_b - u_c ≠ 0 := sub_ne_zero.mpr h_ne
  rw [div_eq_div_iff h_diff_ne hα_ne]
  nlinarith