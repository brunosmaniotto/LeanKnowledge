import Mathlib
open scoped symmDiff

/-- As long as the price change from p₀ to p₁ is not too large, the change in
consumer surplus ΔCS provides a very good approximation to the compensating
variation CV. We formalize: for every ε > 0 there exists δ > 0 such that
if |p₁ − p₀| < δ then |ΔCS − CV| < ε. -/
theorem Claim_4_3_1_g
    (CS : ℝ → ℝ → ℝ)   -- ΔCS as a function of (p₀, p₁)
    (CV : ℝ → ℝ → ℝ)   -- CV as a function of (p₀, p₁)
    (p₀ : ℝ)
    (h_eq : CS p₀ p₀ = CV p₀ p₀)
    (h_cont : ContinuousAt (fun p₁ => CS p₀ p₁ - CV p₀ p₁) p₀) :
    ∀ ε > 0, ∃ δ > 0, ∀ p₁, |p₁ - p₀| < δ → |CS p₀ p₁ - CV p₀ p₁| < ε := by
  intro ε hε
  rw [Metric.continuousAt_iff] at h_cont
  obtain ⟨δ, hδ_pos, hδ⟩ := h_cont ε hε
  refine ⟨δ, hδ_pos, fun p₁ hp₁ => ?_⟩
  have h1 := hδ (show dist p₁ p₀ < δ by rwa [Real.dist_eq])
  rw [h_eq, sub_self, Real.dist_eq, sub_zero] at h1
  exact h1