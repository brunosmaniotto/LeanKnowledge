import Mathlib

theorem equivalence_classes_disjoint_iff_not_related {α : Type} [Setoid α] (x y : α) :
    ¬(x ≈ y) ↔ {z | x ≈ z} ∩ {z | y ≈ z} = ∅ := by
  constructor
  · intro h
    ext z
    constructor
    · intro hz
      exfalso
      rcases hz with ⟨hzx, hzy⟩
      exact h (Setoid.trans hzx (Setoid.symm hzy))
    · intro hz
      simp at hz
  · intro h
    intro hxy
    have h_mem : x ∈ {z | x ≈ z} ∩ {z | y ≈ z} := ⟨Setoid.refl x, Setoid.symm hxy⟩
    rw [h] at h_mem
    simp at h_mem