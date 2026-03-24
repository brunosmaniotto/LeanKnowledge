import Mathlib

open Equiv

theorem powers_perm_elem {α : Type*} (π : Perm α) (i : α) (k : ℕ) (hk_pos : 0 < k)
    (h_exists : ∃ r < k, (π ^ k) i = (π ^ r) i)
    (h_min : ∀ j, 0 < j → j < k → ¬ ∃ s < j, (π ^ j) i = (π ^ s) i) : (π ^ k) i = i := by
  rcases h_exists with ⟨r, hr, h_eq⟩
  by_cases hr0 : r = 0
  · rw [hr0] at h_eq
    simp at h_eq
    exact h_eq
  · have hr_pos : 0 < r := Nat.pos_of_ne_zero hr0
    have hkj_pos : 0 < k - r := Nat.sub_pos_of_lt hr
    have hkj_lt_k : k - r < k := Nat.sub_lt hk_pos hr_pos
    have H : (π ^ r) ((π ^ (k - r)) i) = (π ^ r) i := by
      calc
        (π ^ r) ((π ^ (k - r)) i) = ((π ^ r) * (π ^ (k - r))) i := rfl
        _ = (π ^ (r + (k - r))) i := by rw [pow_add]
        _ = (π ^ k) i := by rw [Nat.add_sub_cancel' (le_of_lt hr)]
        _ = (π ^ r) i := h_eq

    have h_pow_eq : (π ^ (k - r)) i = i := (π ^ r).injective H
    have h_contra : ∃ s < k - r, (π ^ (k - r)) i = (π ^ s) i :=
      ⟨0, hkj_pos, by rw [pow_zero]; exact h_pow_eq⟩
    exact absurd h_contra (h_min (k - r) hkj_pos hkj_lt_k)