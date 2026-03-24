import Mathlib

theorem mem_own_eq_class {α : Type} (S : Set α) (R : α → α → Prop)
    (h_refl : ∀ x ∈ S, R x x) : ∀ x ∈ S, x ∈ {y | R x y} := by
  intro x hx
  exact h_refl x hx