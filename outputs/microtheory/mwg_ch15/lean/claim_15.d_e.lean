import Mathlib

/-- The production possibility set in a 2×2 production model is convex
    (assuming free disposal). We model this as: given two convex production
    sets, the aggregate production possibility set with free disposal is convex. -/
theorem production_possibility_set_convex
    (Y₁ Y₂ : Set (Fin 2 → ℝ))
    (hY₁ : Convex ℝ Y₁)
    (hY₂ : Convex ℝ Y₂)
    (Y : Set (Fin 2 → ℝ))
    (hY : Y = {q | ∃ y₁ ∈ Y₁, ∃ y₂ ∈ Y₂, ∀ i, q i ≤ y₁ i + y₂ i}) :
    Convex ℝ Y := by
  rw [hY]
  intro x hx z hz a b ha hb hab
  obtain ⟨y₁, hy₁, y₂, hy₂, hx_le⟩ := hx
  obtain ⟨w₁, hw₁, w₂, hw₂, hz_le⟩ := hz
  refine ⟨a • y₁ + b • w₁, hY₁ hy₁ hw₁ ha hb hab,
          a • y₂ + b • w₂, hY₂ hy₂ hw₂ ha hb hab, fun i => ?_⟩
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have h1 := hx_le i
  have h2 := hz_le i
  nlinarith