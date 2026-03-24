import Mathlib

theorem right_inverse_injective {S T : Type _} (f : S → T) (g : T → S) (h : f ∘ g = id) : Function.Injective g := by
  have h_left : Function.LeftInverse f g := by
    intro x
    calc
      f (g x) = (f ∘ g) x := rfl
      _ = id x := by rw [h]
      _ = x := rfl
  exact h_left.injective