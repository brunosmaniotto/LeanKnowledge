import Mathlib

variable {S : Type} [Monoid S]

theorem regular_representations_bijective (a : S) (h : IsUnit a) :
    Function.Bijective (fun x : S => a * x) ∧ Function.Bijective (fun x : S => x * a) := by
  constructor
  · rw [← h.unit_spec]
    exact (Units.mulLeft h.unit).bijective
  · rw [← h.unit_spec]
    exact (Units.mulRight h.unit).bijective