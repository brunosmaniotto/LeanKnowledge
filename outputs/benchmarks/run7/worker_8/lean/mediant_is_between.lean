import Mathlib

theorem mediant_between (a b c d : ℝ) (hb : 0 < b) (hd : 0 < d) (h : a / b < c / d) :
    a / b < (a + c) / (b + d) ∧ (a + c) / (b + d) < c / d := by
  have h' : a * d < c * b := by
    calc
      a * d = (a / b) * (b * d) := by field_simp [ne_of_gt hb]
      _ < (c / d) * (b * d) := mul_lt_mul_of_pos_right h (mul_pos hb hd)
      _ = c * b := by field_simp [ne_of_gt hd]

  have hbd_pos : 0 < b + d := by linarith

  have h1 : a / b < (a + c) / (b + d) := by
    have : 0 < (a + c) / (b + d) - a / b := by
      have : (a + c) / (b + d) - a / b = (b * c - a * d) / (b * (b + d)) := by
        field_simp [ne_of_gt hb, ne_of_gt hbd_pos]
        ring
      rw [this]
      exact div_pos (by nlinarith) (by nlinarith)
    linarith

  have h2 : (a + c) / (b + d) < c / d := by
    have : 0 < c / d - (a + c) / (b + d) := by
      have : c / d - (a + c) / (b + d) = (b * c - a * d) / (d * (b + d)) := by
        field_simp [ne_of_gt hd, ne_of_gt hbd_pos]
        ring
      rw [this]
      exact div_pos (by nlinarith) (by nlinarith)
    linarith

  exact ⟨h1, h2⟩