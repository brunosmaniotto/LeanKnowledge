import Mathlib

open Set

theorem coreflexive_subset_diagonal {α : Type u} {r : α → α → Prop} 
    (h : ∀ x y, r x y → x = y) : {p : α × α | r p.1 p.2} ⊆ diagonal α := by
  rintro ⟨x, y⟩ hp
  simp [diagonal, h x y hp]