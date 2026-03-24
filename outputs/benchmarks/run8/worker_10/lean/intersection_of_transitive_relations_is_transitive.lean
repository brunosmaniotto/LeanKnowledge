import Mathlib

theorem Intersection_of_Transitive_Relations_is_Transitive {α : Type u} {r s : α → α → Prop}
    (hr : Transitive r) (hs : Transitive s) : Transitive (r ⊓ s) := by
  intro x y z hxy hyz
  have h1 : r x y := hxy.left
  have h2 : r y z := hyz.left
  have h3 : s x y := hxy.right
  have h4 : s y z := hyz.right
  have h5 : r x z := hr h1 h2
  have h6 : s x z := hs h3 h4
  exact ⟨h5, h6⟩