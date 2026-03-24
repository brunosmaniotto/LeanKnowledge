import Mathlib

noncomputable section

structure CapacityGame where
  b : ℝ → ℝ
  k_I : ℝ
  k_B : ℝ
  q_E_star : ℝ
  b_at_star : b q_E_star = k_B
  k_B_pos : 0 < k_B

def bestResponseI (G : CapacityGame) (q_E : ℝ) : ℝ :=
  min (G.b q_E) G.k_I