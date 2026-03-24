import Mathlib

noncomputable section

structure CostOfAdjustmentFOC where
  q_t : ℝ
  q_t_prev : ℝ
  s_t : ℝ
  V1F : ℝ
  gamma_prime : ℝ
  hs_pos : s_t > 0
  foc_i : q_t = s_t * (1 + gamma_prime)
  foc_ii : q_t_prev = s_t * (V1F + gamma_prime)

theorem Example_20C7
    (m : CostOfAdjustmentFOC)
    (h_denom : 1 + m.gamma_prime ≠ 0) :
    m.q_t_prev / m.q_t = (m.V1F + m.gamma_prime) / (1 + m.gamma_prime) := by
  rw [m.foc_ii, m.foc_i]
  have hs : m.s_t ≠ 0 := ne_of_gt m.hs_pos
  field_simp