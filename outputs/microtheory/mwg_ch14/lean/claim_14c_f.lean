import Mathlib

/-- Hidden information contract: the optimal contract distorts effort to reduce
    information rents. The high-type manager gets utility above ū by the cost
    difference, and reducing low-type effort reduces this rent. -/
theorem hidden_info_distortion
    (g_L g_H : ℝ → ℝ) (e_L e_L_fb u_bar w_H : ℝ)
    (h_cost_adv : ∀ e, g_H e < g_L e)
    (h_rent : w_H - g_H e_L = g_L e_L - g_H e_L + u_bar)
    (h_distort : e_L < e_L_fb)
    (h_rent_pos : g_L e_L - g_H e_L > 0) :
    (w_H - g_H e_L - u_bar > 0) ∧ (e_L < e_L_fb) := by
  constructor
  · linarith
  · exact h_distort