import Mathlib

open Set

theorem non_unital_subring_iff (R : Type*) [Ring R] (S : Set R) :
    (∃ T : NonUnitalSubring R, T.carrier = S) ↔
      S.Nonempty ∧ (∀ x y, x ∈ S → y ∈ S → x - y ∈ S) ∧ (∀ x y, x ∈ S → y ∈ S → x * y ∈ S) := by
  constructor
  · intro ⟨T, hT⟩
    rw [← hT]
    constructor
    · exact ⟨0, T.zero_mem⟩
    constructor
    · intro x y hx hy
      have : x + (-y) ∈ T := T.add_mem hx (T.neg_mem hy)
      simpa [sub_eq_add_neg] using this
    · intro x y hx hy
      exact T.mul_mem hx hy
  · intro ⟨h_nonempty, h_sub, h_mul⟩
    have h0 : (0 : R) ∈ S := by
      obtain ⟨x, hx⟩ := h_nonempty
      have : x - x ∈ S := h_sub x x hx hx
      rwa [sub_self] at this
    have h_neg : ∀ x, x ∈ S → -x ∈ S := by
      intro x hx
      have : (0 : R) - x ∈ S := h_sub 0 x h0 hx
      rwa [zero_sub] at this
    have h_add : ∀ x y, x ∈ S → y ∈ S → x + y ∈ S := by
      intro x y hx hy
      have : x - (-y) ∈ S := h_sub x (-y) hx (h_neg y hy)
      rwa [sub_neg_eq_add] at this
    let T : NonUnitalSubring R :=
      { carrier := S
        zero_mem' := h0
        add_mem' := fun hx hy => h_add _ _ hx hy
        neg_mem' := fun hx => h_neg _ hx
        mul_mem' := fun hx hy => h_mul _ _ hx hy }
    exact ⟨T, rfl⟩