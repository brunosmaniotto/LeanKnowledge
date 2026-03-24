import Mathlib

theorem image_of_element_under_inverse_mapping (S T : Type) (f : S → T) (inv : T → S)
    (h_left_inv : ∀ x, inv (f x) = x) (h_right_inv : ∀ y, f (inv y) = y) :
    ∀ (x : S) (y : T), f x = y ↔ inv y = x := by
  intro x y
  constructor
  · intro h
    calc
      inv y = inv (f x) := by rw [h]
      _ = x := h_left_inv x
  · intro h
    calc
      f x = f (inv y) := by rw [h]
      _ = y := h_right_inv y