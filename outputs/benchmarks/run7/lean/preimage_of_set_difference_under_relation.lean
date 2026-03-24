import Mathlib

open Set

theorem preimage_diff_subset {S T : Type*} (R : S → T → Prop) (C D : Set T) :
    {x | ∃ y ∈ C, R x y} \ {x | ∃ y ∈ D, R x y} ⊆ {x | ∃ y ∈ C \ D, R x y} := by
  intro x hx
  rcases hx with ⟨hx_left, hx_right⟩
  rcases hx_left with ⟨y, hyC, hRxy⟩
  have hy_not_in_D : y ∉ D := by
    intro hyD
    apply hx_right
    exact ⟨y, hyD, hRxy⟩
  exact ⟨y, ⟨hyC, hy_not_in_D⟩, hRxy⟩