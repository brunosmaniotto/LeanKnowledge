import Mathlib

variable {S : Type _} (R : Set (S × S))

theorem symmetric_iff_complement_symmetric :
    Symmetric (fun x y : S => (x, y) ∈ R) ↔ Symmetric (fun x y : S => (x, y) ∈ Rᶜ) := by
  constructor
  · intro hR x y h h'
    exact h (hR h')
  · intro hRc x y h
    by_contra h'
    exact (hRc h') h