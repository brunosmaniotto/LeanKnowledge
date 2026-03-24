import Mathlib

variable {G₁ G₂ : Type*} [Group G₁] [Group G₂]

theorem image_is_subgroup (φ : G₁ →* G₂) : φ.range ≤ (⊤ : Subgroup G₂) := by
  intro x hx
  simp [Subgroup.mem_top]