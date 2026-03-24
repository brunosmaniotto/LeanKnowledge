import Mathlib

theorem homomorphism_on_induced_structure {S T : Type*} [Mul S] [AddCommSemigroup T] (f g : S → T)
    (hf : ∀ x y, f (x * y) = f x + f y) (hg : ∀ x y, g (x * y) = g x + g y) :
    ∀ x y, (f + g) (x * y) = (f + g) x + (f + g) y := by
  intro x y
  calc
    (f + g) (x * y) = f (x * y) + g (x * y) := rfl
    _ = (f x + f y) + (g x + g y) := by rw [hf, hg]
    _ = (f x + g x) + (f y + g y) := by simp [add_comm, add_left_comm, add_assoc]
    _ = (f + g) x + (f + g) y := rfl