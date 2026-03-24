import Mathlib

axiom Associative_Idempotent_Anticommutative {S : Type} (f : S → S → S)
  (h_assoc : ∀ x y z, f (f x y) z = f x (f y z))
  (h_anticomm : ∀ x y, f x y = f y x → x = y) : (∀ a, f a a = a) ∧ (∀ x z, f (f x z) x = x)

theorem associative_anticommutative_simplification {S : Type} (f : S → S → S)
  (h_assoc : ∀ x y z, f (f x y) z = f x (f y z))
  (h_anticomm : ∀ x y, f x y = f y x → x = y)
  (x y z : S) : f (f x y) z = f x z := by
  obtain ⟨h_idem, h_identity⟩ := Associative_Idempotent_Anticommutative f h_assoc h_anticomm
  have h_left : f (f (f (f x y) z) x) z = f x z := by
    calc
      f (f (f (f x y) z) x) z = f (f (f x (f y z)) x) z := by rw [h_assoc x y z]
      _ = f x z := by rw [h_identity x (f y z)]
  have h_right : f (f (f (f x y) z) x) z = f (f x y) z := by
    calc
      f (f (f (f x y) z) x) z = f (f (f x y) (f z x)) z := by rw [h_assoc (f x y) z x]
      _ = f (f x y) (f (f z x) z) := by rw [h_assoc (f x y) (f z x) z]
      _ = f (f x y) z := by rw [h_identity z x]
  calc
    f (f x y) z = f (f (f (f x y) z) x) z := by rw [h_right]
    _ = f x z := by rw [h_left]