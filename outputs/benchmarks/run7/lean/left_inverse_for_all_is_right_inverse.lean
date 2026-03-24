import Mathlib

theorem left_inverse_is_right_inverse {S : Type} [Semigroup S] (e_L : S)
    (h_left_id : ∀ x : S, e_L * x = x) (h_left_inv : ∀ x : S, ∃ x_L : S, x_L * x = e_L) (x : S) :
    ∃ x_L : S, x_L * x = e_L ∧ x * x_L = e_L := by
  rcases h_left_inv x with ⟨x_L, hx_L⟩
  rcases h_left_inv x_L with ⟨x_LL, hx_LL⟩
  have h : x * x_L = e_L := by
    calc
      x * x_L = e_L * (x * x_L) := by rw [h_left_id]
      _ = (x_LL * x_L) * (x * x_L) := by rw [← hx_LL]
      _ = x_LL * (x_L * (x * x_L)) := by rw [mul_assoc]
      _ = x_LL * ((x_L * x) * x_L) := by rw [mul_assoc]
      _ = x_LL * (e_L * x_L) := by rw [hx_L]
      _ = x_LL * x_L := by rw [h_left_id]
      _ = e_L := by rw [hx_LL]
  exact ⟨x_L, hx_L, h⟩