import Mathlib

variable {S : Type} [Setoid S]

theorem eqv_class_unique (x : S) : ∃! C : Set S, (∃ z, C = {y | y ≈ z}) ∧ x ∈ C := by
  refine ⟨{y | y ≈ x}, ⟨⟨x, rfl⟩, Setoid.refl x⟩, ?_⟩
  rintro C ⟨⟨z, rfl⟩, hxC⟩
  ext w
  constructor
  · intro hw
    have hwz : w ≈ z := hw
    have hxz : x ≈ z := hxC
    have hzx : z ≈ x := Setoid.symm hxz
    exact Setoid.trans hwz hzx
  · intro hw
    have hxz : x ≈ z := hxC
    exact Setoid.trans hw hxz