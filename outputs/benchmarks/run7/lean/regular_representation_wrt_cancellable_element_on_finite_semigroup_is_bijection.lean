import Mathlib

theorem regular_representations_bijective (S : Type _) [Semigroup S] [Fintype S] (a : S)
    (h_left : ∀ x y, a * x = a * y → x = y) (h_right : ∀ x y, x * a = y * a → x = y) :
    Function.Bijective (fun x : S => a * x) ∧ Function.Bijective (fun x : S => x * a) := by
  have left_inj : Function.Injective (fun x : S => a * x) := by
    intro x y h
    exact h_left x y h
  have right_inj : Function.Injective (fun x : S => x * a) := by
    intro x y h
    exact h_right x y h
  have left_surj : Function.Surjective (fun x : S => a * x) :=
    (Finite.injective_iff_surjective (f := (fun x : S => a * x))).mp left_inj
  have right_surj : Function.Surjective (fun x : S => x * a) :=
    (Finite.injective_iff_surjective (f := (fun x : S => x * a))).mp right_inj
  exact ⟨⟨left_inj, left_surj⟩, ⟨right_inj, right_surj⟩⟩