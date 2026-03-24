import Mathlib
open Topology

noncomputable section

/-- Exercise 3.6: For a degree-one homogeneous production function,
    partial derivatives are degree-zero homogeneous (Theorem M.B.1), giving:
    (a) MRTS is constant along rays (radially parallel isoquants),
    (b) MPs depend only on input ratio x₂/x₁,
    (c) MP₁ non-decreasing, MP₂ non-increasing in R = x₂/x₁.
    For homothetic g = h ∘ f, the h' cancels in g₁/g₂ = f₁/f₂. -/
theorem exercise_3_6
    (f₁ f₂ : ℝ → ℝ → ℝ)
    -- By Theorem M.B.1, partials of degree-1 homogeneous f are degree-0 homogeneous
    (hf₁_hom : ∀ t x₁ x₂, t > 0 → f₁ (t * x₁) (t * x₂) = f₁ x₁ x₂)
    (hf₂_hom : ∀ t x₁ x₂, t > 0 → f₂ (t * x₁) (t * x₂) = f₂ x₁ x₂)
    -- From Assumption 3.1 (concavity): MP₁ non-decreasing, MP₂ non-increasing in ratio
    (hf₁_mono : ∀ R₁ R₂, R₁ ≤ R₂ → f₁ 1 R₁ ≤ f₁ 1 R₂)
    (hf₂_anti : ∀ R₁ R₂, R₁ ≤ R₂ → f₂ 1 R₂ ≤ f₂ 1 R₁) :
    -- (a) MRTS constant along rays (radially parallel isoquants)
    (∀ t x₁ x₂, t > 0 →
      f₁ (t * x₁) (t * x₂) / f₂ (t * x₁) (t * x₂) = f₁ x₁ x₂ / f₂ x₁ x₂) ∧
    -- (b) MPs depend only on input ratio x₂/x₁
    (∀ x₁ x₂, x₁ > 0 →
      f₁ x₁ x₂ = f₁ 1 (x₂ / x₁) ∧ f₂ x₁ x₂ = f₂ 1 (x₂ / x₁)) ∧
    -- (c) MP₁ non-decreasing, MP₂ non-increasing in R = x₂/x₁
    (∀ x₁ x₂ y₁ y₂, x₁ > 0 → y₁ > 0 → x₂ / x₁ ≤ y₂ / y₁ →
      f₁ x₁ x₂ ≤ f₁ y₁ y₂ ∧ f₂ y₁ y₂ ≤ f₂ x₁ x₂) := by
  -- Key lemma: set t = 1/x₁ to normalize any (x₁, x₂) to (1, x₂/x₁)
  have normalize : ∀ x₁ x₂ : ℝ, x₁ > 0 →
      f₁ x₁ x₂ = f₁ 1 (x₂ / x₁) ∧ f₂ x₁ x₂ = f₂ 1 (x₂ / x₁) := by
    intro x₁ x₂ hx₁
    have hne : x₁ ≠ 0 := hx₁.ne'
    have h₁ := hf₁_hom x₁⁻¹ x₁ x₂ (inv_pos.mpr hx₁)
    have h₂ := hf₂_hom x₁⁻¹ x₁ x₂ (inv_pos.mpr hx₁)
    rw [inv_mul_cancel₀ hne] at h₁ h₂
    have : x₁⁻¹ * x₂ = x₂ / x₁ := by rw [mul_comm, div_eq_mul_inv]
    rw [this] at h₁ h₂
    exact ⟨h₁.symm, h₂.symm⟩
  refine ⟨?_, normalize, ?_⟩
  · -- (a) Direct from degree-0 homogeneity
    intro t x₁ x₂ ht
    rw [hf₁_hom t x₁ x₂ ht, hf₂_hom t x₁ x₂ ht]
  · -- (c) Combine normalization with monotonicity axioms
    intro x₁ x₂ y₁ y₂ hx₁ hy₁ hle
    obtain ⟨nx₁, nx₂⟩ := normalize x₁ x₂ hx₁
    obtain ⟨ny₁, ny₂⟩ := normalize y₁ y₂ hy₁
    exact ⟨by rw [nx₁, ny₁]; exact hf₁_mono _ _ hle,
           by rw [ny₂, nx₂]; exact hf₂_anti _ _ hle⟩