import Mathlib
open Topology

theorem Claim_3_G_f :
    ∃ (a b c d e f g h k : ℝ),
      (∀ v₀ v₁ v₂ : ℝ,
        v₀ * (a * v₀ + b * v₁ + c * v₂) +
        v₁ * (d * v₀ + e * v₁ + f * v₂) +
        v₂ * (g * v₀ + h * v₁ + k * v₂) ≤ 0) ∧
      b ≠ d := by
  refine ⟨-1, 1, 0, -1, -1, 0, 0, 0, -1, ?_, ?_⟩
  · intro v₀ v₁ v₂
    nlinarith [sq_nonneg v₀, sq_nonneg v₁, sq_nonneg v₂]
  · norm_num