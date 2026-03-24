import Mathlib

theorem Claim_12G_b
    (dpi1_dk : ℝ)
    (pi1_k : ℝ)
    (pi1_s1 : ℝ)
    (pi1_s2 : ℝ)
    (ds1_dk : ℝ)
    (ds2_dk : ℝ)
    (h_chain : dpi1_dk = pi1_k + pi1_s1 * ds1_dk + pi1_s2 * ds2_dk)
    (h_foc : pi1_s1 = 0)
    (h_neg_cross : pi1_s2 < 0)
    (h_neg_response : ds2_dk < 0) :
    dpi1_dk = pi1_k + pi1_s2 * ds2_dk
    ∧ 0 < pi1_s2 * ds2_dk := by
  constructor
  · rw [h_chain, h_foc]; ring
  · exact mul_pos_of_neg_of_neg h_neg_cross h_neg_response