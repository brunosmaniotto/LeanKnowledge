import Mathlib
open Filter Topology

theorem geometric_series_converges_absolutely {𝕜 : Type*} [NormedField 𝕜] [CompleteSpace 𝕜] {z : 𝕜} (h : ‖z‖ < 1) :
    HasSum (λ n => z ^ n) ((1 - z)⁻¹) ∧ Summable (λ n => ‖z ^ n‖) := by
  constructor
  · exact hasSum_geometric_of_norm_lt_one h
  · have h_abs : ‖(‖z‖ : ℝ)‖ < 1 := by
      rwa [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg z)]
    have H : Summable (λ n => (‖z‖ : ℝ) ^ n) :=
      summable_geometric_of_norm_lt_one h_abs
    simpa [norm_pow] using H