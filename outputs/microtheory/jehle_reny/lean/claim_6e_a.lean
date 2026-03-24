import Mathlib

theorem Claim_6E_a
    (ũ₁ ũ₂ ū : ℝ)
    (h45 : ū = (ũ₁ + ũ₂) / 2) :
    let ψ₁ := fun u => (ū - ũ₁) + u
    let ψ₂ := fun u => (ū - ũ₂) + u
    -- ψ maps ũ to ū
    ψ₁ ũ₁ = ū ∧ ψ₂ ũ₂ = ū ∧
    -- ψ maps ū to ũ transposed
    ψ₁ ū = ũ₂ ∧ ψ₂ ū = ũ₁ := by
  simp only
  constructor
  · ring
  constructor
  · ring
  constructor <;> linarith