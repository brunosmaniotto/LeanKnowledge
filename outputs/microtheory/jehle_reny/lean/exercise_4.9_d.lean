import Mathlib

theorem Exercise_4_9_d
    (a b c : ℝ)
    (hb : 0 < b)
    (hac : c < a) :
    let q_cournot := (a - c) / (3 * b)
    let p_cournot := a - b * (2 * q_cournot)
    let q_leader := (a - c) / (2 * b)
    let q_follower := (a - c) / (4 * b)
    let p_stackelberg := a - b * (q_leader + q_follower)
    let q_both := 2 * q_leader
    let p_both := a - b * q_both
    p_both = c ∧ p_cournot = (a + 2 * c) / 3 ∧ p_both < p_cournot := by
  refine ⟨?_, ?_, ?_⟩
  · -- p_both = c
    field_simp
    ring
  · -- p_cournot = (a + 2c)/3
    field_simp
    ring
  · -- p_both < p_cournot
    have hac' : 0 < a - c := by linarith
    have hb' : b ≠ 0 := ne_of_gt hb
    rw [show a - b * (2 * ((a - c) / (2 * b))) = c by field_simp; ring]
    rw [show a - b * (2 * ((a - c) / (3 * b))) = (a + 2 * c) / 3 by field_simp; ring]
    linarith