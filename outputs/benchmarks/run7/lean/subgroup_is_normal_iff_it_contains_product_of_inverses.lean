import Mathlib

variable {G : Type*} [Group G] {H : Subgroup G}

theorem Subgroup.normal_iff_forall_mul_inv :
    H.Normal ↔ ∀ a b : G, a * b ∈ H → a⁻¹ * b⁻¹ ∈ H := by
  constructor
  · intro h_normal a b h_ab
    have h_conj : a⁻¹ * (a * b) * (a⁻¹)⁻¹ ∈ H := h_normal.conj_mem (a * b) h_ab (a⁻¹)
    simp only [inv_inv, inv_mul_cancel_left] at h_conj
    have h_inv : (b * a)⁻¹ ∈ H := H.inv_mem h_conj
    rwa [mul_inv_rev] at h_inv
  · intro h_cond
    have h_comm : ∀ a b : G, a * b ∈ H → b * a ∈ H := by
      intro a b h
      have h1 : a⁻¹ * b⁻¹ ∈ H := h_cond a b h
      have h2 : (a⁻¹ * b⁻¹)⁻¹ ∈ H := H.inv_mem h1
      simpa [mul_inv_rev, inv_inv] using h2
    refine { conj_mem := fun n hn g => ?_ }
    have h1 : (n * g⁻¹) * g ∈ H := by
      rw [mul_assoc, inv_mul_cancel, mul_one]
      exact hn
    have h2 : g * (n * g⁻¹) ∈ H := h_comm (n * g⁻¹) g h1
    rwa [← mul_assoc] at h2