import Mathlib

variable {G : Type} [Group G]

theorem one_step_subgroup_test (H : Set G) :
    (∃ h : Subgroup G, (h : Set G) = H) ↔ H.Nonempty ∧ ∀ a b, a ∈ H → b ∈ H → a * b⁻¹ ∈ H := by
  constructor
  · intro ⟨h, hH⟩
    constructor
    · rw [← hH]
      exact ⟨1, h.one_mem⟩
    · intro a b ha hb
      rw [← hH] at ha hb
      rw [← hH]
      exact h.mul_mem ha (h.inv_mem hb)
  · intro ⟨hne, h⟩
    rcases hne with ⟨x, hx⟩
    have h1 : (1 : G) ∈ H := by
      have hx' := h x x hx hx
      rwa [mul_inv_cancel] at hx'
    have hinv : ∀ {a}, a ∈ H → a⁻¹ ∈ H := by
      intro a ha
      have h' := h (1 : G) a h1 ha
      rwa [one_mul] at h'
    have hmul : ∀ {a b}, a ∈ H → b ∈ H → a * b ∈ H := by
      intro a b ha hb
      have hb_inv : b⁻¹ ∈ H := hinv hb
      have h' := h a (b⁻¹) ha hb_inv
      rwa [inv_inv] at h'
    exact ⟨{ carrier := H
             one_mem' := h1
             mul_mem' := fun ha hb => hmul ha hb
             inv_mem' := hinv }, rfl⟩