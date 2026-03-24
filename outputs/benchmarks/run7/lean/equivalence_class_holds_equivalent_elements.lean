import Mathlib

variable {S : Type} [Setoid S]

theorem equiv_class_eq_iff (x y : S) : x ≈ y ↔ {z | z ≈ x} = {z | z ≈ y} := by
  constructor
  · intro h
    ext z
    constructor
    · intro hzx
      exact Setoid.trans hzx h
    · intro hzy
      have h' : y ≈ x := Setoid.symm h
      exact Setoid.trans hzy h'
  · intro h_set
    have hx : x ≈ x := Setoid.refl x
    have mem : x ∈ {z | z ≈ x} := hx
    rw [h_set] at mem
    exact mem