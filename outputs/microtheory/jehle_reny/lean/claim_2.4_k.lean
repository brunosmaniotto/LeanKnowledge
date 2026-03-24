import Mathlib

theorem claim_2_4_k (u_best u_worst : ℝ)
    (h_best : u_best * 1 + (1 - u_best) * 0 = 1)
    (h_worst : u_worst * 1 + (1 - u_worst) * 0 = 0) :
    u_best = 1 ∧ u_worst = 0 := by
  constructor <;> linarith