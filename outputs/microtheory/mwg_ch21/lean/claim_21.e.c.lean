import Mathlib

theorem takes_to_top_maintains_position
    {α : Type*} {I : Type*}
    (X' : Set α)
    (pref pref' : I → α → α → Prop)
    (h_top : ∀ i, ∀ x ∈ X', ∀ y, y ∉ X' → pref' i x y)
    (h_preserve : ∀ i, ∀ x ∈ X', ∀ y ∈ X', pref i x y → pref' i x y)
    (i : I) (x : α) (hx : x ∈ X') (y : α)
    (hxy : y ∈ X' → pref i x y) :
    pref' i x y := by
  by_cases hy : y ∈ X'
  · exact h_preserve i x hx y hy (hxy hy)
  · exact h_top i x hx y hy