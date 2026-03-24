import Mathlib

variable (G : Type*) [Group G]

theorem middle_cancel_iff_comm :
    (∀ (a b c d x : G), a * x * b = c * x * d → a * b = c * d) ↔ ∀ (g h : G), g * h = h * g := by
  constructor
  · intro h_mid g h
    have h1 : g * g⁻¹ * h = h * g⁻¹ * g := by simp
    exact h_mid g h h g (g⁻¹) h1
  · intro h_comm a b c d x h3
    have h_bx : b * x = x * b := h_comm b x
    have h_dx : x * d = d * x := h_comm x d
    have h4 : (a * b) * x = (c * d) * x := by
      calc
        (a * b) * x = a * (b * x) := by rw [mul_assoc]
        _ = a * (x * b) := by rw [h_bx]
        _ = (a * x) * b := by rw [mul_assoc]
        _ = (c * x) * d := by rw [h3]
        _ = c * (x * d) := by rw [mul_assoc]
        _ = c * (d * x) := by rw [h_dx]
        _ = (c * d) * x := by rw [mul_assoc]
    exact mul_right_cancel h4