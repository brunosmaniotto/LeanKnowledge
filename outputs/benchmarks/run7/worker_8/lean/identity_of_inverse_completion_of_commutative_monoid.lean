import Mathlib

variable (S : Type _) [CommMonoid S] (C : Submonoid S)

theorem identity_of_inverse_completion (T : Type _) [CommGroup T] (i : S →* T)
    (h_inj : Function.Injective i) (h : ∀ t : T, ∃ (x : S) (y : C), t = i x * (i y)⁻¹) :
    i 1 = 1 :=
  i.map_one