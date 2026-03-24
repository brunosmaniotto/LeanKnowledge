import Mathlib

theorem left_right_inverse_product {S : Type} [Monoid S] {x y : S}
    (h_left : ∃ a, a * (x * y) = 1) (h_right : ∃ b, (y * x) * b = 1) : IsUnit x ∧ IsUnit y := by
  obtain ⟨a, ha⟩ := h_left
  obtain ⟨b, hb⟩ := h_right
  have h1 : (a * x) * y = 1 := by
    calc
      (a * x) * y = a * (x * y) := by rw [mul_assoc]
      _ = 1 := ha
  have h2 : y * (x * b) = 1 := by
    calc
      y * (x * b) = (y * x) * b := by rw [mul_assoc]
      _ = 1 := hb
  have h3 : a * x = x * b := by
    calc
      a * x = (a * x) * 1 := by simp
      _ = (a * x) * (y * (x * b)) := by rw [h2]
      _ = ((a * x) * y) * (x * b) := by simp [mul_assoc]
      _ = 1 * (x * b) := by rw [h1]
      _ = x * b := by simp
  have h4 : y * (a * x) = 1 := by
    rw [h3]
    exact h2
  have h5 : (y * a) * x = 1 := by
    calc
      (y * a) * x = y * (a * x) := by rw [mul_assoc]
      _ = 1 := h4
  have h6 : x * (b * y) = 1 := by
    calc
      x * (b * y) = (x * b) * y := by rw [mul_assoc]
      _ = (a * x) * y := by rw [h3]
      _ = 1 := h1
  have h7 : y * a = b * y := by
    calc
      y * a = (y * a) * 1 := by simp
      _ = (y * a) * (x * (b * y)) := by rw [h6]
      _ = ((y * a) * x) * (b * y) := by simp [mul_assoc]
      _ = 1 * (b * y) := by rw [h5]
      _ = b * y := by simp
  have h8 : x * (y * a) = 1 := by
    rw [h7]
    exact h6
  have hy : IsUnit y := by
    refine ⟨⟨y, a * x, ?_, ?_⟩, rfl⟩
    · exact h4
    · exact h1
  have hx : IsUnit x := by
    refine ⟨⟨x, y * a, ?_, ?_⟩, rfl⟩
    · exact h8
    · exact h5
  exact ⟨hx, hy⟩