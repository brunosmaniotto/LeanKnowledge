import Mathlib
open Topology

/-- Theorem 2.8 (VNM Uniqueness): VNM utility functions representing the same
    preferences are unique up to positive affine transformations. -/
theorem Theorem_2_8 {G : Type*} (u v : G → ℝ)
    (g₁ g₀ : G) (hne : u g₁ > u g₀)
    (w : G → ℝ)
    (hu : ∀ g, u g = w g * u g₁ + (1 - w g) * u g₀)
    (hv : ∀ g, v g = w g * v g₁ + (1 - w g) * v g₀) :
    (∀ g g', u g ≥ u g' ↔ v g ≥ v g') ↔
    (∃ α β : ℝ, β > 0 ∧ ∀ g, v g = α + β * u g) := by
  constructor
  · -- Necessity: same preferences → positive affine transform
    intro h_same
    have hd : (0 : ℝ) < u g₁ - u g₀ := sub_pos.mpr hne
    have hd_ne : (u g₁ - u g₀) ≠ 0 := hd.ne'
    have hv_gt : v g₁ > v g₀ := by
      by_contra h; push_neg at h
      linarith [(h_same g₀ g₁).mpr h]
    -- β = (v(g₁) - v(g₀)) / (u(g₁) - u(g₀)),  α = v(g₀) - β · u(g₀)
    refine ⟨v g₀ - (v g₁ - v g₀) / (u g₁ - u g₀) * u g₀,
            (v g₁ - v g₀) / (u g₁ - u g₀),
            div_pos (sub_pos.mpr hv_gt) hd, fun g => ?_⟩
    -- Substitute EU decompositions for v(g) and u(g), clear denominator, close by ring
    rw [hv g, hu g]; field_simp; ring
  · -- Sufficiency: positive affine transform → same preferences
    rintro ⟨α, β, hβ, hf⟩ g g'
    rw [hf g, hf g']
    constructor <;> intro h <;> nlinarith