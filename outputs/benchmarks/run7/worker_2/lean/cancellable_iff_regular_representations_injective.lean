import Mathlib

variable {S : Type} [Mul S]

theorem cancellable_iff_injective_regular (a : S) :
    (∀ x y, a * x = a * y → x = y) ∧ (∀ x y, x * a = y * a → x = y) ↔
    (Function.Injective (fun x : S => a * x) ∧ Function.Injective (fun x : S => x * a)) := by
  constructor
  · intro h
    exact ⟨h.1, h.2⟩
  · intro h
    exact ⟨h.1, h.2⟩