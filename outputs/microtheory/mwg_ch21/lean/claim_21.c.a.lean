import Mathlib
open Topology

theorem Claim_21_C_a {α : Type*} (R : α → α → Prop)
    (hrefl : ∀ x, R x x)
    (htrans : ∀ x y z, R x y → R y z → R x z)
    (htotal : ∀ x y, x ≠ y → (R x y ∧ ¬R y x) ∨ (R y x ∧ ¬R x y)) :
    (∀ x y, R x y ∨ R y x) ∧ (∀ x y z, R x y → R y z → R x z) := by
  exact ⟨fun x y => by
    by_cases h : x = y
    · subst h; left; exact hrefl x
    · cases htotal x y h with
      | inl h => left; exact h.1
      | inr h => right; exact h.1, htrans⟩