import Mathlib
open Topology

theorem multilateral_externality_exceeds_optimum
    (N : ℕ) (hN : 2 ≤ N)
    (c : ℝ) (hc : 0 < c)
    (d : ℝ) (hd : 0 < d)
    (q_nash q_opt : ℝ)
    (h_nash : q_nash = c / d)
    (h_opt : q_opt = c / (↑N * d)) :
    q_opt < q_nash := by
  rw [h_nash, h_opt]
  have hNpos : (0 : ℝ) < (↑N : ℝ) := by positivity
  have hN_gt_one : (1 : ℝ) < (↑N : ℝ) := by
    exact_mod_cast Nat.lt_of_lt_of_le (by norm_num : 1 < 2) hN
  have hd_lt_Nd : d < ↑N * d := by nlinarith
  exact div_lt_div_of_pos_left hc hd hd_lt_Nd