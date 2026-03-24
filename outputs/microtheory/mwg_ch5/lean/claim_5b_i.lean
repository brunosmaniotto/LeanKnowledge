import Mathlib

open Set

theorem Claim_5B_i
    {L : Type*} [AddCommMonoid L] [Module ℝ L]
    (Y : Set L)
    (hconv : Convex ℝ Y)
    (hinaction : (0 : L) ∈ Y) :
    let Yhat : Set (L × ℝ) := { p | ∃ y ∈ Y, ∃ α : ℝ, 0 ≤ α ∧ p = (α • y, α) }
    (∀ p ∈ Yhat, ∀ t : ℝ, 0 ≤ t → (t • p.1, t * p.2) ∈ Yhat) ∧
    (∀ y ∈ Y, (y, (1 : ℝ)) ∈ Yhat) := by
  constructor
  · intro p hp t ht
    obtain ⟨y, hy, α, hα, rfl⟩ := hp
    simp only [Set.mem_setOf_eq]
    exact ⟨y, hy, t * α, mul_nonneg ht hα, by simp [smul_smul, mul_comm t α]⟩
  · intro y hy
    simp only [Set.mem_setOf_eq]
    exact ⟨y, hy, 1, zero_le_one, by simp⟩