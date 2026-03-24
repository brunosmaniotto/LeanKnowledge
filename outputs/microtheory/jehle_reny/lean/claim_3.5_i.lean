import Mathlib
open Topology

theorem Claim_3_5_i
    (p y₁ tvc tfc : ℝ)
    (hy₁ : y₁ > 0)
    (π₁ : ℝ) (hπ₁ : π₁ = p * y₁ - tvc - tfc)
    (π₀ : ℝ) (hπ₀ : π₀ = -tfc)
    (avc : ℝ) (havc : avc = tvc / y₁) :
    (π₁ - π₀ ≥ 0 ↔ p * y₁ - tvc ≥ 0) ∧
    (p * y₁ - tvc ≥ 0 ↔ p ≥ avc) := by
  constructor
  · subst hπ₁; subst hπ₀
    constructor <;> intro h <;> linarith
  · subst havc
    constructor
    · intro h
      rw [ge_iff_le, div_le_iff₀ hy₁]
      linarith
    · intro h
      rw [ge_iff_le, div_le_iff₀ hy₁] at h
      linarith