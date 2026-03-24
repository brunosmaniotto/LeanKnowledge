import Mathlib

/-- If x is in the core of the r-replica economy E_r, then by the equal treatment
property, all consumers of the same type receive the same bundle. Consequently,
core allocations in E_r are r-fold copies of allocations in E_1. -/
theorem Claim_5e_e
    {I : Type*} [Fintype I] [DecidableEq I]
    {r : ℕ} (hr : 0 < r)
    {L : Type*} [Fintype L]
    (x : I → Fin r → L → ℝ)
    (h_equal_treatment : ∀ i : I, ∀ k₁ k₂ : Fin r, x i k₁ = x i k₂) :
    ∃ y : I → L → ℝ, ∀ i : I, ∀ k : Fin r, x i k = y i := by
  exact ⟨fun i => x i ⟨0, hr⟩, fun i k => h_equal_treatment i k ⟨0, hr⟩⟩